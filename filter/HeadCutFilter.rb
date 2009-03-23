#
# HeadCut filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class HeadCutFilter < Filter
	def HeadCutFilter::description
		[
			'HeadCutFilter',
			'ʸƬ���',
			'��ʸ����Ƭ�Ԥ�����ꤷ���ѥ�����˥ޥå�����ԤޤǤ�������ե��륿�Ǥ����ѥ�᥿�˥ѥ������ҤȤĻ��ꤷ�ޤ���'
		]
	end

	def initialize( *opt )
		super
		raise FilterError.new( "HeadCutFilter: Need a pattern." ) if @options.size != 1
		@pat = /#{@options[0]}/
	end

	def body_filter( body )
		head = true
		body.to_a.collect do |item|
			if head then
				head = false if @pat =~ item
				nil
			else
				item
			end
		end.join
	end
end

