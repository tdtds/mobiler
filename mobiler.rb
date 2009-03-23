#!/home/spc/bin/ruby -Ke
#
# mobiler: customizable e-mail compressor and splitter $Revision: 1.15 $
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
MOBILER_VERSION = '1.2.0'

#
# exnhanced String class
#
require 'nkf'
class String
	def to_jis
		NKF::nkf( '-Xdj -m0', self )
	end

	def to_euc
		NKF::nkf( '-Xde -m0', self )
	end
end

#
# Safe
#
require 'thread'
module Safe
	def safe( level = 4 )
		result = nil
		Thread.start {
			$SAFE = level
			result = yield
		}.join
		result
  end
end

#
# Filter class
#
class Filter
	class FilterError < StandardError; end

	attr_reader :options
	def initialize( *opt )
		@options = opt.flatten
	end

	def description
		self.class.description
	end

	def header_filter( header )
		return header
	end

	def body_filter( body )
		return body
	end
end

#
# Mobiler class
#
class Mobiler
	include Safe
	attr_reader :split_size, :split_limit

	#
	# init
	#
	def initialize( conf, path )
		$: << "#{path}/filter"
		@filters = []

		filter_list = []
		split_size = 100000
		split_limit = 10

		begin
			eval( File::readlines( "#{path}/mobiler.conf" ).join )
			current_conf = File::readlines( "#{path}/conf/#{conf}.conf" ).join
			safe do 
				eval( current_conf )
			end
			filter_list = filter_list || []
			@split_size = split_size || 100000
			@split_limit = split_limit || 10
		rescue
			logging
			raise
		end
	
		filter_list.each do |pair|
			begin
				eval( "require '#{pair[0]}'" )
				filter = nil
				safe do
					filter = eval( "#{pair[0]}.new( #{pair[1]} )" )
				end
				@filters << filter if filter
			rescue
				logging
			end
		end
	end

	#
	# filters: iterator of filter list
	#
	def filters
		@filters.each do |filter| yield filter end
	end

	#
	# filter: header and body
	#
	def filter( mail )
		header, body = mail.to_euc.split( "\n\n", 2 )
		header.sub!( /^>?From .*?\n/, '' )
		header = header_filter( header + "\n" )
		body = body_filter( body )
		[header, body]
	end

	#
	# header filter
	#
	def header_filter( header )
		@filters.each do |filter|
			header = filter.header_filter( header.clone )
		end
		header
	end

	#
	# body filter
	#
	def body_filter( body )
		@filters.each do |filter|
			body = filter.body_filter( body.clone )
		end
		body
	end

	#
	# split
	#
	def split( header, body )
		is_subject = false
		subject = ''
		header = header.to_a.collect { |item|
			if /^Subject:/i =~ item then
				is_subject = true
				subject << item
				nil
			elsif /^\s+/ =~ item and is_subject
				subject << item
				nil
			else
				is_subject = false
				item
			end
		}.join.chomp
		subject.chomp!

		mails = []
		body_tmp = ''
		body.to_jis.each_line do |line|
			if body_tmp.size > 0 and (body_tmp.size + line.size) > (@split_size - 10) then
				mails << "#{header}\n\n#{body_tmp}"
				body_tmp = ''
			end
			body_tmp += line
		end
		mails << "#{header}\n\n#{body_tmp}" if body_tmp.size > 0
		a = mails.size
		if a > 1 then
			mails.each_with_index do |mail, i|
				part = "#{'%02d' % (i+1)}/#{'%02d' % a}"
				mails[i] = "#{subject}(#{part})\n#{mail}[#{part}]\n" if i < @split_limit
			end
		else
			mails[0] = "#{subject}\n#{mails[0]}"
		end
		mails
	end

	#
	# deliver
	#
	def deliver( rcpt_to, mails, delay = 0 )
		raise StandardError::new( 'No addresses receipt mails.' ) if rcpt_to.size < 1
		mails.each_with_index do |mail,idx|
			break if idx >= @split_limit
			case $how
			when 'command'
				open( "|#{$delivery_command} #{rcpt_to.join ' '}", 'w' ) do |f|
					f.write mail
				end
				sleep delay if delay > 0
			when 'smtp'
				require 'net/smtp'
				ENV['HOSTNAME'] = Socket::gethostname if not ENV['HOSTNAME'] # for Ruby 1.4's net/smtp
				Net::SMTP.start( $smtp_host, $smtp_port ) do |smtp|
					smtp.ready( $mail_from, rcpt_to ) do |adapter| adapter.write( mail ) end
				end
				sleep delay if delay > 0
			when 'file' # for debug
				File::open( "result.#{'%02d' % idx}", 'w' ) do |f| f.write( mail ) end
				#sleep delay if delay > 0
			else
				raise StandardError::new( 'Bad $how valiable.' )
			end
		end
	end

	#
	# logging
	#
	def logging
		msg = %Q|#{Time.now} #$!\n    #{$@.join "\n    "}|
		if $logfile then 
			File::open( $logfile, 'a' ) do |f| f.puts( msg ) end
		else
			$stderr.puts msg
		end
	end

end

if __FILE__ == $0 then
	def usage
		puts "Mobiler #{MOBILER_VERSION}"
		puts "usage: #{File::basename $0} [-d delay] <conf_name> <to_address...>"
		exit
	end

	require 'getoptlong'
	parser = GetoptLong::new
	delay = 0
	parser.set_options( ['--delay', '-d', GetoptLong::REQUIRED_ARGUMENT] )
	parser.each do |opt, arg|
		if opt == '--delay' then
			delay = arg.to_i
		else
			usage
		end
	end
	usage if ARGV.length < 2
	begin
		mobiler = Mobiler::new( ARGV.shift, File::dirname( $0 ) )
		header, body = mobiler.filter( $stdin.read )
		mails = mobiler.split( header, body )
		mobiler.deliver( ARGV, mails, delay )
	rescue
		$stderr.puts $! if $logfile
	end
end

