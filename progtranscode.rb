#!/usr/bin/ruby

#Initial decode to raw
`flac -d -o storage/output.raw --force-raw-format --endian=little \
--sign=signed input.flac`
fout = File.open 'storage/final.raw', 'wb'

while File.size('storage/output.raw') > 0
    fin = File.open 'storage/output.raw', 'rb'
    fout.write(fin.read(44100*2*2)) #Move one second of audio
            #(44100 samples/second, 2 bytes/sample, 2 channels)
    remainder = fin.read
    fin.close
    #Now write it back, with the first second clipped off
    outTemp = File.open 'storage/output.raw', 'wb'
    outTemp.write remainder
    outTemp.close

    puts "**** %d bytes left"%(remainder.length)

    #Encode mp3
    `lame -r --bitwidth 16 --signed --little-endian -V 2 \
    storage/output.raw storage/output.mp3`
    #Then decode it
    `lame --decode  --bitwidth 16 --signed --little-endian \
    storage/output.mp3 storage/output.raw`
end

#Flac it
`flac --force-raw-format --endian=little --sign=signed --channels=2 \
--bps=16 --sample-rate=44100 -o output.flac storage/output.raw`

#Get rid of extra/uneeded files
File.safe_unlink('storage/output.raw', 'storage/final.raw',
        'storage/output.mp3')

puts 'All done encoding.'
