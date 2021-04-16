# frozen_string_literal: true

# Copyright (c) 2021 Samuel Y. Ayele
require 'test/unit'
require 'webmock'
require 'json'
require 'addressable'
require 'rest-client'
require 'byebug'
require 'nokogiri'
require 'down'
require 'fileutils'

require_relative '../libs/daily_downloader'

include WebMock::API
WebMock.enable!

class DailyDownloadsTest < Test::Unit::TestCase
  dapc_index_file = File.read('webmocks/DAPCindex.html')
  dasc_index_file = File.read('webmocks/DASCindex.html')
  daccp_index_file = File.read('webmocks/DACCPindex.html')
  daccsp_index_file = File.read('webmocks/DACCSindex.html')
  # ------------------------------------------------------stub requests
  stub_request(:get, 'https://justice.gov.bc.ca/courts/DAPCindex.html')
    .with(
      headers: {
        'Accept'          => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Host'            => 'justice.gov.bc.ca',
        'User-Agent'      => 'rest-client/2.1.0 (linux x86_64) ruby/3.0.0p0'
      }
    )
    .to_return(status: 200, body: dapc_index_file, headers: {})
  # ------------------------------------------------------stub requests
  stub_request(:get, 'https://justice.gov.bc.ca/courts/DASCindex.html')
    .with(
      headers: {
        'Accept'          => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Host'            => 'justice.gov.bc.ca',
        'User-Agent'      => 'rest-client/2.1.0 (linux x86_64) ruby/3.0.0p0'
      }
    )
    .to_return(status: 200, body: dasc_index_file, headers: {})
  # ------------------------------------------------------stub requests
  stub_request(:get, 'https://justice.gov.bc.ca/courts/DACCPindex.html')
    .with(
      headers: {
        'Accept'          => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Host'            => 'justice.gov.bc.ca',
        'User-Agent'      => 'rest-client/2.1.0 (linux x86_64) ruby/3.0.0p0'
      }
    )
    .to_return(status: 200, body: daccp_index_file, headers: {})
  # ------------------------------------------------------stub requests
  stub_request(:get, 'https://justice.gov.bc.ca/courts/DACCSindex.html')
    .with(
      headers: {
        'Accept'          => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Host'            => 'justice.gov.bc.ca',
        'User-Agent'      => 'rest-client/2.1.0 (linux x86_64) ruby/3.0.0p0'
      }
    )
    .to_return(status: 200, body: daccsp_index_file, headers: {})

  def test_process_all_urls_exists
    assert_true DailyDownloader.method_defined? :process_all_urls
  end

  def test_url_list_exists
    assert_true DailyDownloader.method_defined? :url_list
  end

  def test_get_request_exists
    assert_true DailyDownloader.method_defined? :get_request
  end

  def test_extract_links_exists
    assert_true DailyDownloader.method_defined? :extract_links
  end

  def test_keep_log_exists
    assert_true DailyDownloader.method_defined? :keep_log
  end

  def test_display_error_exists
    assert_true DailyDownloader.method_defined? :display_error
  end

  def test_display_message_exists
    assert_true DailyDownloader.method_defined? :display_message
  end

  def test_create_top_level_folders_exists
    assert_true DailyDownloader.method_defined? :create_top_level_folders
  end

  def test_create_daily_folders_exists
    assert_true DailyDownloader.method_defined? :create_daily_folders
  end

  # ---------------------------------------------------------------------------
  def test_url_list
    daily_downloader = DailyDownloader.new
    url_list = daily_downloader.url_list
    assert_equal 4, url_list.count
    assert_kind_of Array, url_list
    assert_not_nil url_list
  end

  # def test_process_all_urls
  #   daily_downloader = DailyDownloader.new
  #   url_list = daily_downloader.url_list
  #   assert_equal 4, url_list.count
  #   assert_kind_of Array, url_list
  #   assert_not_nil url_list
  # end

  def test_display_message
    daily_downloader = DailyDownloader.new
    assert_true daily_downloader.display_message('', 'notice')
    assert_true daily_downloader.display_message('', 'status')
    assert_nil daily_downloader.display_message('', '')
  end

  # def test_display_error
  #   daily_downloader = DailyDownloader.new
  #   assert_true daily_downloader.display_error('', '')
  # end

  # def test_keep_log; end

  def test_target_content
    daily_downloader = DailyDownloader.new
    response = daily_downloader.get_request('https://justice.gov.bc.ca/courts/DAPCindex.html', {})
    target_content = daily_downloader.target_content(response)
    assert_not_nil target_content
  end

  def test_extract_links
    daily_downloader = DailyDownloader.new
    response = daily_downloader.get_request('https://justice.gov.bc.ca/courts/DAPCindex.html', {})
    target_content = daily_downloader.target_content(response)
    content_links = daily_downloader.extract_links(target_content)
    assert_not_nil content_links
    assert_not_empty content_links
    assert_kind_of Array, content_links
    assert_equal 100, content_links.count
  end

  # def test_download_file
  #   daily_downloader = DailyDownloader.new
  #   response = daily_downloader.get_request('https://justice.gov.bc.ca/courts/DAPCindex.html', {})
  #   target_content = daily_downloader.extract_target_content(response)
  #   content_links = daily_downloader.extract_links(target_content)
  #   links_download_result = daily_downloader.download_file(content_links)
  #   assert_not_nil links_download_result
  #   assert_not_empty links_download_result
  #   assert_kind_of Boolean, links_download_result
  #   assert_true links_download_result
  # end

  def test_create_top_level_folders
    # daily_downloader = DailyDownloader.new
    # assert_true daily_downloader.create_top_level_folders([])
  end

  def test_create_daily_folders
    # daily_downloader = DailyDownloader.new
    # assert_true daily_downloader.create_daily_folders('https://justice.gov.bc.ca/courts/DAPCindex.html')
  end

  def test_get_request
    request_tester = DailyDownloader.new
    response = request_tester.get_request('https://justice.gov.bc.ca/courts/DAPCindex.html', {})
    assert_not_nil response
  end
end
