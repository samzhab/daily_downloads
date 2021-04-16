#!/usr/bin/env ruby
# frozen_string_literal: true

# Copyright (c) 2021 Samuel Y. Ayele
require 'byebug'
require 'down'
require 'date'
# ----------------------------------------------------------------------------
class DailyDownloader
  def start; end

  def get_my_persons(search); end

  def login_with_session_id(session_id)
    additional_url = "?sessionID=#{session_id}&language=En&redirect="\
    'showDocumentSearch|doc_search_by=TendSimp!catalogueType='\
    'SystemCatalogue!BypassCookie=yes'
    url = "#{BASE_URL}#{LOGIN_URL}#{additional_url}"
    begin
      get_request(url, {}, {})
    rescue RestClient::ExceptionWithResponse => e
      display_error(e, url.to_s)
    end
  end

  def target_content; end

  def url_list; end

  def extract_target_content(_response); end

  def extract_links(_target_content); end

  def save_json; end

  def download_links(_target_content); end

  def load_json; end

  def keep_log; end

  def display_message; end

  def check_folders; end

  def create_folders
    Process.spawn('mkdir ../PDFs && mkdir JSONs && mkdir HTMLs')
  end

  def target_element; end

  def display_process_message(content, flag)
    case flag
    when 'notice'
      puts "[Notice][BC_BIDS] Finished processing ... #{content}"
    when 'status'
      puts "[Status][BC_BIDS] Processing #{content} now..."
    end
  end

  def display_error(error, url)
    puts "[Error][BC_BIDS] - #{error} for #{url}"
  end

  def get_request(url, headers)
    RestClient::Request.execute(method:  :get,
                                url:     Addressable::URI.parse(url)
                                           .normalize.to_str,
                                headers: headers, verify_ssl: false,
                                timeout: 50)
  end

  def post_request(url, headers)
    RestClient::Request.execute(method:  :post,
                                url:     Addressable::URI.parse(url)
                                           .normalize.to_str,
                                headers: headers, verify_ssl: false,
                                payload: payload,
                                timeout: 50)
  end
end

# :TODO
# https://justice.gov.bc.ca/courts/DAPCindex.html
# https://justice.gov.bc.ca/courts/DASCindex.html
# https://justice.gov.bc.ca/courts/DACCPindex.html
# https://justice.gov.bc.ca/courts/DACCSindex.html

# the story
# four get requests to links above, get response nokogiri through it and get all links
# get all files for each court type, in a loop, each time adding date to file and save

# my_downloader = DailyDownloader.new
# my_downloader.start
