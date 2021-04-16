#!/usr/bin/env ruby
# frozen_string_literal: true

# Copyright (c) 2021 Samuel Y. Ayele
require 'webmock'
require 'json'
require 'addressable'
require 'rest-client'
require 'byebug'
require 'nokogiri'
require 'down'
require 'fileutils'

# include WebMock::API
# WebMock.enable!
DAPC_FILE = File.read('webmocks/DAPCindex.html')
DASC_FILE = File.read('webmocks/DASCindex.html')
DACCP_FILE = File.read('webmocks/DACCPindex.html')
DACCS_FILE = File.read('webmocks/DACCSindex.html')
COURTS_URI = 'https://justice.gov.bc.ca/courts/'

class DailyDownloader
  def process_all_urls
    all_urls = url_list
    create_top_level_folders(all_urls)
    all_urls.each do |url|
      # html_webmock_file = File.read("webmocks/#{url.split('/').last}")
      # pdf_webmock_file = File.read('webmocks/PDFs/empty.pdf')
      # # ------------------------------------------------------stub requests
      # stub_request(:get, url)
      #   .with(
      #     headers: {
      #       'Accept'          => '*/*',
      #       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      #       'Host'            => 'justice.gov.bc.ca',
      #       'User-Agent'      => 'rest-client/2.1.0 (linux x86_64) ruby/3.0.0p0'
      #     }
      #   )
      #   .to_return(status: 200, body: html_webmock_file, headers: {})
      # ------------------------------------------------------stub requests
      create_daily_folders(url)
      response = get_request(url, {})
      targeted_content = target_content(response)
      extracted_links = extract_links(targeted_content)
      folder_name = url.split('/').last.split('.').first[/[A-Z]+/]
      extracted_links.each do |link|
        # # ------------------------------------------------------stub requests
        # stub_request(:get, link)
        #   .with(
        #     headers: {
        #       'Accept'          => '*/*',
        #       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        #       'User-Agent'      => 'Down/5.2.0'
        #     }
        #   )
        #   .to_return(status: 200, body: pdf_webmock_file, headers: {})
        download_file(link, folder_name)
        display_message(link, 'notice')
      end
    end
  end

  def target_content(response)
    Nokogiri::HTML(response.body).css('p')[1]
  end

  def url_list
    ['https://justice.gov.bc.ca/courts/DAPCindex.html',
     'https://justice.gov.bc.ca/courts/DASCindex.html',
     'https://justice.gov.bc.ca/courts/DACCPindex.html',
     'https://justice.gov.bc.ca/courts/DACCSindex.html']
  end

  def extract_links(target_content)
    all_links = []
    index = 1
    max_limit = target_content.children.count - 3
    while index <= max_limit
      item = COURTS_URI.to_s + target_content.children[index.to_s.to_i]
                                             .attribute('href').value
      display_message(item, 'notice')
      all_links << item
      break if index >= max_limit

      index += 3
    end
    all_links
  end

  def download_file(link, folder_name)
    Down.download(link, destination: "PDFs/#{folder_name}/#{Date.today}")

    # display_message(link, 'status')
    folder_details = "PDFs/#{folder_name}/#{Date.today}"
    file_name = "#{link.split('/').last.split('.').first}.pdf".sub('(', '\(')
    file_name = file_name.sub(')', '\)')
    Process.spawn("mv #{folder_details}/down\*.pdf #{folder_details}/#{file_name}")
  end

  def keep_log; end

  def display_message(item, flag)
    case flag
    when 'notice'
      puts "[Notice][DCFD] Finished processing #{item}..."
      true
    when 'status'
      puts "[Status][DCFD] Processing #{item} now..."
      true
    end
  end

  def create_top_level_folders(all_urls)
    Process.spawn('mkdir PDFs/')
    all_urls.each do |url|
      folder_name = url.split('/').last.split('.').first[/[A-Z]+/]
      Process.spawn("mkdir PDFs/#{folder_name}")
    end
  end

  def create_daily_folders(url)
    folder_name = url.split('/').last.split('.').first[/[A-Z]+/]
    Process.spawn("mkdir PDFs/#{folder_name}/#{Date.today}")
  end

  def display_error(error, url)
    puts "[Error][DCFD] - #{error} for #{url}"
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

# my_downloader = DailyDownloader.new
# my_downloader.process_all_urls
