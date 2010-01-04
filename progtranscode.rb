#!/usr/bin/ruby

#Initial decode to raw
`flac -d -o output.raw --force-raw-format --endian=little \
--sign=signed input.flac`

while File.size 'output.raw' > 0
    
end
