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

  def test_get_request_exists
    assert_true DailyDownloader.method_defined? :get_request
  end

  def test_process_request_exists
    assert_true DailyDownloader.method_defined? :process_request
  end

  def test_target_content_exists
    assert_true DailyDownloader.method_defined? :target_content
  end

  def test_save_json_exists
    assert_true DailyDownloader.method_defined? :save_json
  end

  def test_load_json_exists
    assert_true DailyDownloader.method_defined? :load_json
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

  def test_check_folders_exists
    assert_true DailyDownloader.method_defined? :check_folders
  end

  def test_create_folders_exists
    assert_true DailyDownloader.method_defined? :create_folders
  end

  def test_target_element_exists
    assert_true DailyDownloader.method_defined? :target_element
  end

  def test_get_request
    request_tester = DailyDownloader.new
    response = request_tester.get_request('https://justice.gov.bc.ca/courts/DAPCindex.html', {})
    assert_false response.nil?
  end

  def test_target_element
    request_tester = DailyDownloader.new
    response = request_tester.get_request('https://justice.gov.bc.ca/courts/DAPCindex.html', {})
    assert_false response.nil?
    # target = Nokogiri::HTML(response).css('#body').children[8]
  end
end
