#!ruby
# encoding: UTF-8
# author: Rafael Polo
# created_at 13.out.2009
# updated_at 1.jul.2014

# TorrentInfo kernel v0.6
# + SomBarato, BaixoGavea, MakingOff

require 'digest/sha1'
require 'open-uri'
require 'json'
require 'timeout'

class TorrentInfo

  def initialize(path)
    return nil unless File.exists?(path)
    begin
      @torrent = File.bdecode(path)
    rescue BEncode::DecodeError => e
      puts "#{e}".red
      # binding.pry if Rails.env.development? # debug
      return nil
    end
    return nil unless valid?
  end

  def valid?
    (@torrent && @torrent["info"]) ? true : false
  end

  def name
    @torrent['info']['name'].strip
  end

  def hash
    Digest::SHA1.hexdigest(@torrent["info"].bencode)
  end

  def size
    total_size = 0
    if @torrent['info']
      if files = @torrent['info']['files']
        files.each do |file|
          total_size += file['length']
        end
      else
        single_file_size = @torrent['info']['length'] || nil
        total_size = single_file_size if single_file_size
      end
    end
    total_size
  end

  def magnet_link
    params = {}
    params[:xt] = "urn:btih:" << hash
    params[:dn] = CGI.escape(@torrent["info"]["name"])
    params[:tr] = announce_list
    magnet_uri  = "magnet:?xt=#{params.delete(:xt)}"
    magnet_uri << "&" << Rack::Utils.build_query(params)
    magnet_uri
  end

  def announce_list
    list = []
    if @torrent['announce-list']
      @torrent['announce-list'].each do |announce|
        list << announce[0].strip if announce[0]
      end
    else
      list << @torrent['announce']
    end
    list.uniq
  end

  def get_seeds_count
    trackers = []
    announce_list.each do |t|
      if tracker = valid_tracker(t)
        trackers << tracker
      end
    end
    # try all known live trackers
    trackers += Tracker.last_alives

    peers = []
    trackers.uniq.uniq.each do |t|
      begin
        tracker = Tracker.find_by_url(tracker)
        handler = Torckapi.tracker(t)
        # todo: quais peers são seeds?
        tracker_seeds = []
        timeout(8) do
          response = handler.scrape([hash])
          tracker_seeds = response.data[hash][:seeders]
          tracker.update(last_alive_at: DateTime.now)
        end
      rescue Exception => e
        puts "#{t} => #{e}".red
      end
      if tracker_seeds > 0
        puts "#{t} => #{tracker_seeds}".green
      else
        puts "#{t} => 0".red
      end
      peers << tracker_seeds
    end
    uniq_peers = peers.flatten.uniq.size
    puts "#{name} => #{uniq_peers} peers".yellow
    uniq_peers
  end

  def valid_tracker t
    # URL válida?
    return nil if !t || !(t =~ /^#{URI::regexp}$/)
    tracker = Tracker.find_or_initialize_by(url: t)
    # novo tracker?
    if tracker.id == nil
      tracker.save
      return tracker
    else
      # só valide se tracker estiver vivo no último mês
      return tracker.last_alive_at && (tracker.last_alive_at > 1.month.ago) ? tracker : false
    end
  end

end
