These notes originate from the [libvshadow project](https://github.com/libyal/libvshadow).

# Test image
Instructions to create VSS test images. These instruction assume you both have a Linux and Windows Vista or later machine available.

Start out on Linux.

Create a partition of 1G (1 GiB) of type 7 HPFS/NTFS/exFAT:
```
sudo fdisk /dev/sdh1
```

Note that according to the following [technet article](http://social.technet.microsoft.com/Forums/en-US/dataprotectionmanager2012beta/thread/75be8322-4350-4df2-bc17-b4d60b4f4c81) the NTFS volume must be at least 1 GB to be able to store Volume Shadow Snapshots. We're using 1 GiB to be on the safe side.

Fill the test parition with 0-byte values.
```
sudo dd if=/dev/zero of=/dev/sdh
```

Next add sector markers e.g. with the following Python script:
```
#!/usr/bin/python
import argparse
import os

parser = argparse.ArgumentParser(
          description="Mark every block in a file.")

parser.add_argument(
 "filename", metavar="filename", type=unicode, nargs=1,
  help="the name of the file to mark")

parser.add_argument(
 "-b", metavar="block_size", type=int, action="store",
 default=512, help="the block size")

arguments = parser.parse_args()

file_object = open( arguments.filename[ 0 ], "r+b" )

file_object.seek( 0, os.SEEK_END )

file_size = file_object.tell()

block_size = arguments.b

for offset in range( 0, file_size, block_size ):
	file_object.seek( offset, os.SEEK_SET )

	file_object.write( "0x{0:08x}".format( offset ) )

file_object.close()
```

```
sudo python script.py /dev/sdh1
```

Make sure to sync the changes to the disk:
```
sudo umount /dev/sdh1
```

Switch to Windows.

Quick format the partition as an NTFS volume. For the sake of these instructions we assign it drive letter F.

Get a copy of diskshadow.exe. This tools is part of Windows 2008 server and later but works on Windows 7 as well.

Run diskshadow as Administrator and run the following commands to manually create a snapshot:
```
SET CONTEXT PERSISTENT
ADD VOLUME F:
CREATE
```

The test scenarios mentioned below require having a least 3 snapshots.

After we're done with creating snapshots, safely remove the drive and switch back to Linux.

To create a RAW image of the NTFS volume with the snapshots.
```
sudo dd if=dev/sdh1 of=vsstest.raw
```

## Test scenarios
For the following test scenarios uses range that contain sector markers e.g.

```
01450000  30 78 30 31 35 35 30 30  30 30 00 00 00 00 00 00  |0x01550000......|
01450010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
...
014501f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
```

The difference between the offset and the sector marker is cause by the fact that the offset is relative from the start of the volume and the sector marker relative from the start of the disk, which in this case is 0x100000.

### Block descriptors
Find the store block list offset of the most recent store e.g. 0x31cdc000. Find the offset and values of the last block descriptor e.g. a block descriptor at offset: 0x31cdfd20
```
original offset             : 0x14f70000
relative offset             : 0x0078c000
offset                      : 0x32464000
flags                       : 0x00000000
allocation bitmap           : 0x00000000
```

#### Block descriptor: 0x00000000
Find a block inside the store with sector markers e.g. 0x32468000 for this block we manually add a block descriptor e.g.
```
original offset             : 0x01450000
relative offset             : 0x00790000
offset                      : 0x32468000
flags                       : 0x00000000
allocation bitmap           : 0x00000000
```

On Windows when reading block 0x01450000 it should now map to 0x32468000. The sector marker should confirm this.

#### Block descriptor: 0x00000001

#### Block descriptor: 0x00000002
* flags: 0x00000002, allocation bitmap: 0x000000ff
* flags: 0x00000002, allocation bitmap: 0x0000ff00
* flags: 0x00000002, allocation bitmap: 0x00ff0000
* flags: 0x00000002, allocation bitmap: 0xff000000
* flags: 0x00000002, allocation bitmap: 0x0f0f0f0f
* flags: 0x00000002, allocation bitmap: 0xf0f0f0f0
* flags: 0x00000002, allocation bitmap: 0xffffffff

**TODO**

#### Block descriptor: 0x00000004

Find a block inside the store with sector markers e.g. 0x3246c000 for this block we manually add a block descriptor e.g.
```
original offset             : 0x01454000
relative offset             : 0x00794000
offset                      : 0x3246c000
flags                       : 0x00000004
allocation bitmap           : 0x00000000
```

Make sure that the original offset points somewhere allocated. On Windows when reading block 0x01454000 it should be not changed.

#### Block descriptor: 0x00000008
* flags: 0x00000008
* flags: 0x00000018
* flags: 0x00000028
* flags: 0x00000048
* flags: 0x00000088

**TODO**

#### To do

Do the same for single block descriptors with the following characteristics:
* flags: 0x00000010
* flags: 0x00000020
* flags: 0x00000040
* flags: 0x00000080

Unsupported flags:
* flags: 0x00000030
* flags: 0x00000038
* flags: 0x00000050
* flags: 0x00000058
* flags: 0x00000060
* flags: 0x00000068
* flags: 0x00000070
* flags: 0x00000078
* flags: 0x00000090
* flags: 0x00000098
* flags: 0x000000a0
* flags: 0x000000a8
* flags: 0x00000100

Overlay block descriptors:

**TODO**

# Useful commands and scripts
Listing the shadows of a specific volume:
```
vssadmin list shadows  /For=F:
```

Python script to write block descriptors test scenarios:
```
#!/usr/bin/python
import argparse
import os

def uint32_copy_to_byte_stream( integer ):
  byte_stream = chr( integer & 0xff )
  integer >>= 8
  byte_stream += chr( integer & 0xff )
  integer >>= 8
  byte_stream += chr( integer & 0xff )
  integer >>= 8
  byte_stream += chr( integer & 0xff )
  return byte_stream

def uint64_copy_to_byte_stream( integer ):
  byte_stream = chr( integer & 0xff )
  integer >>= 8
  byte_stream += chr( integer & 0xff )
  integer >>= 8
  byte_stream += chr( integer & 0xff )
  integer >>= 8
  byte_stream += chr( integer & 0xff )
  integer >>= 8
  byte_stream += chr( integer & 0xff )
  integer >>= 8
  byte_stream += chr( integer & 0xff )
  integer >>= 8
  byte_stream += chr( integer & 0xff )
  integer >>= 8
  byte_stream += chr( integer & 0xff )
  return byte_stream

class BlockDescriptor( object ):
  def __init__( self, original_offset, relative_offset, offset ):
    self.original_offset = original_offset
    self.relative_offset = relative_offset
    self.offset = offset
    self.flags = 0;
    self.allocation_bitmap = 0;

  def copy_to_byte_stream( self ):
    byte_stream = uint64_copy_to_byte_stream( self.original_offset )
    byte_stream += uint64_copy_to_byte_stream( self.relative_offset )
    byte_stream += uint64_copy_to_byte_stream( self.offset )
    byte_stream += uint32_copy_to_byte_stream( self.flags )
    byte_stream += uint32_copy_to_byte_stream( self.allocation_bitmap )
    return byte_stream

  def next_block( self ):
    self.original_offset += 0x4000
    self.relative_offset += 0x4000
    self.offset += 0x4000

parser = argparse.ArgumentParser(
          description="Write block descriptor test scenarios.")

parser.add_argument(
 "filename", metavar="filename", type=unicode, nargs=1,
  help="the name of the file to write to")

parser.add_argument(
 "-r", action="store_true", help="revert the changes")

arguments = parser.parse_args()

block_descriptor_data_offset = 0x31cdfd40

block_descriptor = BlockDescriptor( 0x01450000, 0x00790000, 0x32468000 )
block_descriptor.flags = 0x00000000
byte_stream = block_descriptor.copy_to_byte_stream()

if arguments.r:
  byte_stream = '\0' * len( byte_stream )

if len( byte_stream ) > 0x4000 - ( block_descriptor_data_offset % 0x4000 ):
  print "Block descriptor test data too large for store block."
else:
  file_object = open( arguments.filename[ 0 ], "r+b" )
  file_object.seek( block_descriptor_data_offset, os.SEEK_SET )
  file_object.write( byte_stream )
  file_object.close()
```

