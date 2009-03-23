#
# Set Return-Path filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class SetReturnPathFilter < Filter
	def SetReturnPathFilter::description
		[
			'SetReturnPathFilter',
			'ヘッダに「Return-Path」を指定する',
			'メールの配送中にエラーが発生した時に、エラーメールを配信する先を指定します。この指定がないとエラーは発信者もしくは元々指定してあったReturn-Pathに返りますが、これがまずい場合に指定します。パラメタにはエラーメール配信先のアドレスを指定します。'
		]
	end

	def initialize( *opt )
		super
		raise FilterError::new( 'SetReturnPath: no mail address' ) if not @options[0]
		@path = @options[0]
	end

	def header_filter( header )
		header.sub( /^Return-Path:(.*)$/, 'X-Return-Path:\1' ).concat( "Return-Path: <#{@path}>\n" )
	end
end

