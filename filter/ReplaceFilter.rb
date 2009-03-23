#
# ReplaceFilter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class ReplaceFilter < Filter
	def ReplaceFilter::description
		[
			'ReplaceFilter',
			'�ִ�',
			'Ǥ�դ�����ɽ���������ʸ������֤������ޤ����ѥ�᥿�ˤ��ִ�����ʸ������ִ����ʸ����򥫥�ޤǶ��ڤäƸ�ߤ��¤٤Ʋ�����(��: "���󥿡��ͥå�","INET","�ѥ�����","PC")'
		]
	end

	def initialize( *opt )
		super
		raise FilterError.new( "ReplaceFilter: Argument Number must be even." ) if @options.size % 2 == 1
		@pair = to_pair( @options )
	end

	def body_filter( body )
		@pair.each do |p|
			body.gsub!( p[0], p[1] )
		end
		body
	end

private
	def to_pair( opt )
		pair = []
		opt.each_with_index do |item, i|
			pair << [/#{item}/, opt[i+1]] if i % 2 == 0
		end
		pair
	end
end

