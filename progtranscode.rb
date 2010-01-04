#!/usr/bin/ruby

#Initial decode to raw
`flac -d -o output.raw --force-raw-format --endian=little \
--sign=signed input.flac`

i = 0
while File.size 'output.raw' > 0
    fin = File.open 'output.raw', 'rb'
    fout = File.open "storage/#{i}", 'wb'
    fout.write(fin.read(44100*2*2)) #Move one second of audio
            #(44100 samples/second, 2 bytes/sample, 2 channels)
    fin.close
    fout.close

    i += 1
end
