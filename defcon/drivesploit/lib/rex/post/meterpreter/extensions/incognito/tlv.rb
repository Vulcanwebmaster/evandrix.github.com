module Rex
module Post
module Meterpreter
module Extensions
module Incognito

TLV_TYPE_INCOGNITO_LIST_TOKENS_DELEGATION        	= TLV_META_TYPE_STRING | (TLV_EXTENSIONS + 2)
TLV_TYPE_INCOGNITO_LIST_TOKENS_IMPERSONATION        	= TLV_META_TYPE_STRING | (TLV_EXTENSIONS + 3)
TLV_TYPE_INCOGNITO_LIST_TOKENS_ORDER       	= TLV_META_TYPE_UINT| (TLV_EXTENSIONS + 4)
TLV_TYPE_INCOGNITO_IMPERSONATE_TOKEN    = TLV_META_TYPE_STRING | (TLV_EXTENSIONS + 5)
TLV_TYPE_INCOGNITO_GENERIC_RESPONSE    = TLV_META_TYPE_STRING | (TLV_EXTENSIONS + 6)
TLV_TYPE_INCOGNITO_USERNAME    = TLV_META_TYPE_STRING | (TLV_EXTENSIONS + 7)
TLV_TYPE_INCOGNITO_PASSWORD    = TLV_META_TYPE_STRING | (TLV_EXTENSIONS + 8)
TLV_TYPE_INCOGNITO_SERVERNAME    = TLV_META_TYPE_STRING | (TLV_EXTENSIONS + 9)
TLV_TYPE_INCOGNITO_GROUPNAME    = TLV_META_TYPE_STRING | (TLV_EXTENSIONS + 10)

end
end
end
end
end