#
# TailCut filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class TailCutFilter < Filter
	def TailCutFilter::description
		[
			'TailCutFilter',
			'ʸ�����',
			'���ꤷ���ѥ�����˥ޥå�����Ԥ���ʸ���ޤǤ�������ե��륿�Ǥ����ѥ�᥿�˥ѥ������ҤȤĻ��ꤷ�ޤ���'
		]
	end

	def initialize( *opt )
		super
		raise FilterError.new( "TailCutFilter: Need a pattern." ) if @options.size != 1
		@pat = /#{@options[0]}/
	end

	def body_filter( body )
		tail = false
		body.to_a.collect do |item|
			tail = true if @pat =~ item
			if tail then
				nil
			else
				item
			end
		end.join
	end
end

