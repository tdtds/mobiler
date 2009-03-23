#
# Range filter $Revision: 1.2 $
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class RangeFilter < Filter
	def RangeFilter::description
		[
			'RangeFilter',
			'�ϰϻ�����',
			'���ꤷ���ϰϤ˴ޤޤ��Ԥ�������ե��륿�Ǥ����ѥ�᥿�˳��ϥѥ�����Ƚ�λ�ѥ�������ߤ˻��ꤷ�ޤ���ʣ���Υѥ����������ǽ�Ǥ������ϰϤ�����ҤϤǤ��ޤ���'
		]
	end

	def initialize( *opt )
		super
		raise FilterError.new( "RangeFilter: Bad Argument Number #{opt.size} " ) if @options.size % 2 == 1
		@pair = pair( @options )
	end

	def body_filter( body )
		range = nil
		body.to_a.collect do |item|
			if not range then
				@pair.each_with_index do |pair,i|
					if pair[0] =~ item then
						range = i
						break
					end
				end
				range ? nil : item
			else
				range = nil if @pair[range][1] =~ item
				nil
			end
		end.join
	end

private
	def pair( opt )
		a = []
		opt.each_with_index do |item, i|
			a << [/#{item}/, /#{opt[i+1]}/] if i % 2 == 0
		end
		a
	end
end

