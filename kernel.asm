
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2d 10 80       	mov    $0x80102de0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 20 6e 10 	movl   $0x80106e20,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 20 40 00 00       	call   80104080 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 27 6e 10 	movl   $0x80106e27,0x4(%esp)
8010009b:	80 
8010009c:	e8 cf 3e 00 00       	call   80103f70 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 85 40 00 00       	call   80104170 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 fa 40 00 00       	call   80104260 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 3f 3e 00 00       	call   80103fb0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 92 1f 00 00       	call   80102110 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 2e 6e 10 80 	movl   $0x80106e2e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 9b 3e 00 00       	call   80104050 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 47 1f 00 00       	jmp    80102110 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 3f 6e 10 80 	movl   $0x80106e3f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 5a 3e 00 00       	call   80104050 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 0e 3e 00 00       	call   80104010 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 62 3f 00 00       	call   80104170 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 0b 40 00 00       	jmp    80104260 <release>
    panic("brelse");
80100255:	c7 04 24 46 6e 10 80 	movl   $0x80106e46,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 f9 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 dd 3e 00 00       	call   80104170 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 e3 33 00 00       	call   80103690 <myproc>
801002ad:	8b 40 2c             	mov    0x2c(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 48 39 00 00       	call   80103c10 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 4a 3f 00 00       	call   80104260 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 82 13 00 00       	call   801016a0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 2c 3f 00 00       	call   80104260 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 64 13 00 00       	call   801016a0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 d5 23 00 00       	call   80102750 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 4d 6e 10 80 	movl   $0x80106e4d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 9f 77 10 80 	movl   $0x8010779f,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 ec 3c 00 00       	call   801040a0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 61 6e 10 80 	movl   $0x80106e61,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 f2 53 00 00       	call   80105800 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 42 53 00 00       	call   80105800 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 36 53 00 00       	call   80105800 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 2a 53 00 00       	call   80105800 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 4f 3e 00 00       	call   80104350 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 92 3d 00 00       	call   801042b0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 65 6e 10 80 	movl   $0x80106e65,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 90 6e 10 80 	movzbl -0x7fef9170(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 79 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 5d 3b 00 00       	call   80104170 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 25 3c 00 00       	call   80104260 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 5a 10 00 00       	call   801016a0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 68 3b 00 00       	call   80104260 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 78 6e 10 80       	mov    $0x80106e78,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 d4 39 00 00       	call   80104170 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 7f 6e 10 80 	movl   $0x80106e7f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 a6 39 00 00       	call   80104170 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 34 3a 00 00       	call   80104260 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 f9 34 00 00       	call   80103db0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 74 35 00 00       	jmp    80103ea0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 88 6e 10 	movl   $0x80106e88,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 16 37 00 00       	call   80104080 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 04 19 00 00       	call   801022a0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sm, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 df 2c 00 00       	call   80103690 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 44 21 00 00       	call   80102b00 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 29 15 00 00       	call   80101ef0 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 47 02 00 00    	je     80100c18 <exec+0x278>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 c7 0c 00 00       	call   801016a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 55 0f 00 00       	call   80101950 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 f8 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a08:	e8 63 21 00 00       	call   80102b70 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 df 5f 00 00       	call   80106a10 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 bd 0e 00 00       	call   80101950 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 99 5d 00 00       	call   80106870 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 98 5c 00 00       	call   801067b0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 62 5e 00 00       	call   80106990 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 c5 0d 00 00       	call   80101900 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 2b 20 00 00       	call   80102b70 <end_op>
	if((sm = allocuvm(pgdir, sm - PGSIZE, sm)) == 0){ goto bad; }
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	c7 44 24 08 fc ff ff 	movl   $0x7ffffffc,0x8(%esp)
80100b52:	7f 
80100b53:	c7 44 24 04 fc ef ff 	movl   $0x7fffeffc,0x4(%esp)
80100b5a:	7f 
80100b5b:	89 04 24             	mov    %eax,(%esp)
80100b5e:	e8 0d 5d 00 00       	call   80106870 <allocuvm>
80100b63:	85 c0                	test   %eax,%eax
80100b65:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
80100b6b:	0f 84 8f 00 00 00    	je     80100c00 <exec+0x260>
  for(argc = 0; argv[argc]; argc++) {
80100b71:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b74:	8b 00                	mov    (%eax),%eax
80100b76:	85 c0                	test   %eax,%eax
80100b78:	0f 84 9c 01 00 00    	je     80100d1a <exec+0x37a>
80100b7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b81:	31 d2                	xor    %edx,%edx
80100b83:	8b 9d e4 fe ff ff    	mov    -0x11c(%ebp),%ebx
80100b89:	8d 71 04             	lea    0x4(%ecx),%esi
80100b8c:	89 cf                	mov    %ecx,%edi
80100b8e:	89 f1                	mov    %esi,%ecx
80100b90:	89 d6                	mov    %edx,%esi
80100b92:	89 ca                	mov    %ecx,%edx
80100b94:	eb 28                	jmp    80100bbe <exec+0x21e>
80100b96:	66 90                	xchg   %ax,%ax
80100b98:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
    ustack[3+argc] = sp;
80100b9e:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100ba4:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100bab:	83 c6 01             	add    $0x1,%esi
80100bae:	8b 02                	mov    (%edx),%eax
80100bb0:	89 d7                	mov    %edx,%edi
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	74 7d                	je     80100c33 <exec+0x293>
80100bb6:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bb9:	83 fe 20             	cmp    $0x20,%esi
80100bbc:	74 42                	je     80100c00 <exec+0x260>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bbe:	89 04 24             	mov    %eax,(%esp)
80100bc1:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100bc7:	e8 04 39 00 00       	call   801044d0 <strlen>
80100bcc:	f7 d0                	not    %eax
80100bce:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bd0:	8b 07                	mov    (%edi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bd2:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bd5:	89 04 24             	mov    %eax,(%esp)
80100bd8:	e8 f3 38 00 00       	call   801044d0 <strlen>
80100bdd:	83 c0 01             	add    $0x1,%eax
80100be0:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100be4:	8b 07                	mov    (%edi),%eax
80100be6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100bea:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bee:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bf4:	89 04 24             	mov    %eax,(%esp)
80100bf7:	e8 04 61 00 00       	call   80106d00 <copyout>
80100bfc:	85 c0                	test   %eax,%eax
80100bfe:	79 98                	jns    80100b98 <exec+0x1f8>
    freevm(pgdir);
80100c00:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c06:	89 04 24             	mov    %eax,(%esp)
80100c09:	e8 82 5d 00 00       	call   80106990 <freevm>
  return -1;
80100c0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c13:	e9 fa fd ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100c18:	e8 53 1f 00 00       	call   80102b70 <end_op>
    cprintf("exec: fail\n");
80100c1d:	c7 04 24 a1 6e 10 80 	movl   $0x80106ea1,(%esp)
80100c24:	e8 27 fa ff ff       	call   80100650 <cprintf>
    return -1;
80100c29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c2e:	e9 df fd ff ff       	jmp    80100a12 <exec+0x72>
80100c33:	89 f2                	mov    %esi,%edx
  ustack[3+argc] = 0;
80100c35:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c3c:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c40:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c47:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c4d:	89 da                	mov    %ebx,%edx
80100c4f:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c51:	83 c0 0c             	add    $0xc,%eax
80100c54:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c56:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c5a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c60:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c68:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c6f:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c72:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c75:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7b:	e8 80 60 00 00       	call   80106d00 <copyout>
80100c80:	85 c0                	test   %eax,%eax
80100c82:	0f 88 78 ff ff ff    	js     80100c00 <exec+0x260>
  for(last=s=path; *s; s++)
80100c88:	8b 45 08             	mov    0x8(%ebp),%eax
80100c8b:	0f b6 10             	movzbl (%eax),%edx
80100c8e:	84 d2                	test   %dl,%dl
80100c90:	74 19                	je     80100cab <exec+0x30b>
80100c92:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c95:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100c98:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100c9b:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100c9e:	0f 44 c8             	cmove  %eax,%ecx
80100ca1:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100ca4:	84 d2                	test   %dl,%dl
80100ca6:	75 f0                	jne    80100c98 <exec+0x2f8>
80100ca8:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cab:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cbb:	00 
80100cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc0:	89 f8                	mov    %edi,%eax
80100cc2:	83 c0 74             	add    $0x74,%eax
80100cc5:	89 04 24             	mov    %eax,(%esp)
80100cc8:	e8 c3 37 00 00       	call   80104490 <safestrcpy>
  curproc->pgdir = pgdir;
80100ccd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100cd3:	8b 77 0c             	mov    0xc(%edi),%esi
  curproc->spgcount = 1;
80100cd6:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  curproc->tf->eip = elf.entry;  // main
80100cdd:	8b 47 20             	mov    0x20(%edi),%eax
  curproc->pgdir = pgdir;
80100ce0:	89 4f 0c             	mov    %ecx,0xc(%edi)
  curproc->sz = sz;
80100ce3:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100ce9:	89 0f                	mov    %ecx,(%edi)
  curproc->sm = sm;
80100ceb:	8b 8d e4 fe ff ff    	mov    -0x11c(%ebp),%ecx
80100cf1:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->tf->eip = elf.entry;  // main
80100cf4:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100cfa:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100cfd:	8b 47 20             	mov    0x20(%edi),%eax
80100d00:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d03:	89 3c 24             	mov    %edi,(%esp)
80100d06:	e8 05 59 00 00       	call   80106610 <switchuvm>
  freevm(oldpgdir);
80100d0b:	89 34 24             	mov    %esi,(%esp)
80100d0e:	e8 7d 5c 00 00       	call   80106990 <freevm>
  return 0;
80100d13:	31 c0                	xor    %eax,%eax
80100d15:	e9 f8 fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d1a:	8b 9d e4 fe ff ff    	mov    -0x11c(%ebp),%ebx
80100d20:	31 d2                	xor    %edx,%edx
80100d22:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d28:	e9 08 ff ff ff       	jmp    80100c35 <exec+0x295>
80100d2d:	66 90                	xchg   %ax,%ax
80100d2f:	90                   	nop

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d36:	c7 44 24 04 ad 6e 10 	movl   $0x80106ead,0x4(%esp)
80100d3d:	80 
80100d3e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d45:	e8 36 33 00 00       	call   80104080 <initlock>
}
80100d4a:	c9                   	leave  
80100d4b:	c3                   	ret    
80100d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d59:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d5c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d63:	e8 08 34 00 00       	call   80104170 <acquire>
80100d68:	eb 11                	jmp    80100d7b <filealloc+0x2b>
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d79:	74 25                	je     80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d82:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100d89:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d90:	e8 cb 34 00 00       	call   80104260 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d95:	83 c4 14             	add    $0x14,%esp
      return f;
80100d98:	89 d8                	mov    %ebx,%eax
}
80100d9a:	5b                   	pop    %ebx
80100d9b:	5d                   	pop    %ebp
80100d9c:	c3                   	ret    
80100d9d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100da0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100da7:	e8 b4 34 00 00       	call   80104260 <release>
}
80100dac:	83 c4 14             	add    $0x14,%esp
  return 0;
80100daf:	31 c0                	xor    %eax,%eax
}
80100db1:	5b                   	pop    %ebx
80100db2:	5d                   	pop    %ebp
80100db3:	c3                   	ret    
80100db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 14             	sub    $0x14,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dd1:	e8 9a 33 00 00       	call   80104170 <acquire>
  if(f->ref < 1)
80100dd6:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd9:	85 c0                	test   %eax,%eax
80100ddb:	7e 1a                	jle    80100df7 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100ddd:	83 c0 01             	add    $0x1,%eax
80100de0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de3:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dea:	e8 71 34 00 00       	call   80104260 <release>
  return f;
}
80100def:	83 c4 14             	add    $0x14,%esp
80100df2:	89 d8                	mov    %ebx,%eax
80100df4:	5b                   	pop    %ebx
80100df5:	5d                   	pop    %ebp
80100df6:	c3                   	ret    
    panic("filedup");
80100df7:	c7 04 24 b4 6e 10 80 	movl   $0x80106eb4,(%esp)
80100dfe:	e8 5d f5 ff ff       	call   80100360 <panic>
80100e03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	57                   	push   %edi
80100e14:	56                   	push   %esi
80100e15:	53                   	push   %ebx
80100e16:	83 ec 1c             	sub    $0x1c,%esp
80100e19:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e23:	e8 48 33 00 00       	call   80104170 <acquire>
  if(f->ref < 1)
80100e28:	8b 57 04             	mov    0x4(%edi),%edx
80100e2b:	85 d2                	test   %edx,%edx
80100e2d:	0f 8e 89 00 00 00    	jle    80100ebc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e33:	83 ea 01             	sub    $0x1,%edx
80100e36:	85 d2                	test   %edx,%edx
80100e38:	89 57 04             	mov    %edx,0x4(%edi)
80100e3b:	74 13                	je     80100e50 <fileclose+0x40>
    release(&ftable.lock);
80100e3d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e44:	83 c4 1c             	add    $0x1c,%esp
80100e47:	5b                   	pop    %ebx
80100e48:	5e                   	pop    %esi
80100e49:	5f                   	pop    %edi
80100e4a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e4b:	e9 10 34 00 00       	jmp    80104260 <release>
  ff = *f;
80100e50:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e54:	8b 37                	mov    (%edi),%esi
80100e56:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e59:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e5f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e62:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e65:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e6f:	e8 ec 33 00 00       	call   80104260 <release>
  if(ff.type == FD_PIPE)
80100e74:	83 fe 01             	cmp    $0x1,%esi
80100e77:	74 0f                	je     80100e88 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100e79:	83 fe 02             	cmp    $0x2,%esi
80100e7c:	74 22                	je     80100ea0 <fileclose+0x90>
}
80100e7e:	83 c4 1c             	add    $0x1c,%esp
80100e81:	5b                   	pop    %ebx
80100e82:	5e                   	pop    %esi
80100e83:	5f                   	pop    %edi
80100e84:	5d                   	pop    %ebp
80100e85:	c3                   	ret    
80100e86:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100e88:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e8c:	89 1c 24             	mov    %ebx,(%esp)
80100e8f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100e93:	e8 b8 23 00 00       	call   80103250 <pipeclose>
80100e98:	eb e4                	jmp    80100e7e <fileclose+0x6e>
80100e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ea0:	e8 5b 1c 00 00       	call   80102b00 <begin_op>
    iput(ff.ip);
80100ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ea8:	89 04 24             	mov    %eax,(%esp)
80100eab:	e8 10 09 00 00       	call   801017c0 <iput>
}
80100eb0:	83 c4 1c             	add    $0x1c,%esp
80100eb3:	5b                   	pop    %ebx
80100eb4:	5e                   	pop    %esi
80100eb5:	5f                   	pop    %edi
80100eb6:	5d                   	pop    %ebp
    end_op();
80100eb7:	e9 b4 1c 00 00       	jmp    80102b70 <end_op>
    panic("fileclose");
80100ebc:	c7 04 24 bc 6e 10 80 	movl   $0x80106ebc,(%esp)
80100ec3:	e8 98 f4 ff ff       	call   80100360 <panic>
80100ec8:	90                   	nop
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	53                   	push   %ebx
80100ed4:	83 ec 14             	sub    $0x14,%esp
80100ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100edd:	75 31                	jne    80100f10 <filestat+0x40>
    ilock(f->ip);
80100edf:	8b 43 10             	mov    0x10(%ebx),%eax
80100ee2:	89 04 24             	mov    %eax,(%esp)
80100ee5:	e8 b6 07 00 00       	call   801016a0 <ilock>
    stati(f->ip, st);
80100eea:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eed:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ef1:	8b 43 10             	mov    0x10(%ebx),%eax
80100ef4:	89 04 24             	mov    %eax,(%esp)
80100ef7:	e8 24 0a 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100efc:	8b 43 10             	mov    0x10(%ebx),%eax
80100eff:	89 04 24             	mov    %eax,(%esp)
80100f02:	e8 79 08 00 00       	call   80101780 <iunlock>
    return 0;
  }
  return -1;
}
80100f07:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f0a:	31 c0                	xor    %eax,%eax
}
80100f0c:	5b                   	pop    %ebx
80100f0d:	5d                   	pop    %ebp
80100f0e:	c3                   	ret    
80100f0f:	90                   	nop
80100f10:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f18:	5b                   	pop    %ebx
80100f19:	5d                   	pop    %ebp
80100f1a:	c3                   	ret    
80100f1b:	90                   	nop
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f20 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	57                   	push   %edi
80100f24:	56                   	push   %esi
80100f25:	53                   	push   %ebx
80100f26:	83 ec 1c             	sub    $0x1c,%esp
80100f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f32:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f36:	74 68                	je     80100fa0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f38:	8b 03                	mov    (%ebx),%eax
80100f3a:	83 f8 01             	cmp    $0x1,%eax
80100f3d:	74 49                	je     80100f88 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f3f:	83 f8 02             	cmp    $0x2,%eax
80100f42:	75 63                	jne    80100fa7 <fileread+0x87>
    ilock(f->ip);
80100f44:	8b 43 10             	mov    0x10(%ebx),%eax
80100f47:	89 04 24             	mov    %eax,(%esp)
80100f4a:	e8 51 07 00 00       	call   801016a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f4f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f53:	8b 43 14             	mov    0x14(%ebx),%eax
80100f56:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f5a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f5e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f61:	89 04 24             	mov    %eax,(%esp)
80100f64:	e8 e7 09 00 00       	call   80101950 <readi>
80100f69:	85 c0                	test   %eax,%eax
80100f6b:	89 c6                	mov    %eax,%esi
80100f6d:	7e 03                	jle    80100f72 <fileread+0x52>
      f->off += r;
80100f6f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f72:	8b 43 10             	mov    0x10(%ebx),%eax
80100f75:	89 04 24             	mov    %eax,(%esp)
80100f78:	e8 03 08 00 00       	call   80101780 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7d:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100f7f:	83 c4 1c             	add    $0x1c,%esp
80100f82:	5b                   	pop    %ebx
80100f83:	5e                   	pop    %esi
80100f84:	5f                   	pop    %edi
80100f85:	5d                   	pop    %ebp
80100f86:	c3                   	ret    
80100f87:	90                   	nop
    return piperead(f->pipe, addr, n);
80100f88:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f8b:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100f8e:	83 c4 1c             	add    $0x1c,%esp
80100f91:	5b                   	pop    %ebx
80100f92:	5e                   	pop    %esi
80100f93:	5f                   	pop    %edi
80100f94:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100f95:	e9 36 24 00 00       	jmp    801033d0 <piperead>
80100f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fa5:	eb d8                	jmp    80100f7f <fileread+0x5f>
  panic("fileread");
80100fa7:	c7 04 24 c6 6e 10 80 	movl   $0x80106ec6,(%esp)
80100fae:	e8 ad f3 ff ff       	call   80100360 <panic>
80100fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fc0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 2c             	sub    $0x2c,%esp
80100fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fcc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fcf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fd5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80100fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100fdc:	0f 84 ae 00 00 00    	je     80101090 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100fe2:	8b 07                	mov    (%edi),%eax
80100fe4:	83 f8 01             	cmp    $0x1,%eax
80100fe7:	0f 84 c2 00 00 00    	je     801010af <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fed:	83 f8 02             	cmp    $0x2,%eax
80100ff0:	0f 85 d7 00 00 00    	jne    801010cd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff9:	31 db                	xor    %ebx,%ebx
80100ffb:	85 c0                	test   %eax,%eax
80100ffd:	7f 31                	jg     80101030 <filewrite+0x70>
80100fff:	e9 9c 00 00 00       	jmp    801010a0 <filewrite+0xe0>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101008:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010100b:	01 47 14             	add    %eax,0x14(%edi)
8010100e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101011:	89 0c 24             	mov    %ecx,(%esp)
80101014:	e8 67 07 00 00       	call   80101780 <iunlock>
      end_op();
80101019:	e8 52 1b 00 00       	call   80102b70 <end_op>
8010101e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101021:	39 f0                	cmp    %esi,%eax
80101023:	0f 85 98 00 00 00    	jne    801010c1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101029:	01 c3                	add    %eax,%ebx
    while(i < n){
8010102b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010102e:	7e 70                	jle    801010a0 <filewrite+0xe0>
      int n1 = n - i;
80101030:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101033:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101038:	29 de                	sub    %ebx,%esi
8010103a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101040:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101043:	e8 b8 1a 00 00       	call   80102b00 <begin_op>
      ilock(f->ip);
80101048:	8b 47 10             	mov    0x10(%edi),%eax
8010104b:	89 04 24             	mov    %eax,(%esp)
8010104e:	e8 4d 06 00 00       	call   801016a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101053:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101057:	8b 47 14             	mov    0x14(%edi),%eax
8010105a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010105e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101061:	01 d8                	add    %ebx,%eax
80101063:	89 44 24 04          	mov    %eax,0x4(%esp)
80101067:	8b 47 10             	mov    0x10(%edi),%eax
8010106a:	89 04 24             	mov    %eax,(%esp)
8010106d:	e8 de 09 00 00       	call   80101a50 <writei>
80101072:	85 c0                	test   %eax,%eax
80101074:	7f 92                	jg     80101008 <filewrite+0x48>
      iunlock(f->ip);
80101076:	8b 4f 10             	mov    0x10(%edi),%ecx
80101079:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010107c:	89 0c 24             	mov    %ecx,(%esp)
8010107f:	e8 fc 06 00 00       	call   80101780 <iunlock>
      end_op();
80101084:	e8 e7 1a 00 00       	call   80102b70 <end_op>
      if(r < 0)
80101089:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010108c:	85 c0                	test   %eax,%eax
8010108e:	74 91                	je     80101021 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101090:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80101093:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101098:	5b                   	pop    %ebx
80101099:	5e                   	pop    %esi
8010109a:	5f                   	pop    %edi
8010109b:	5d                   	pop    %ebp
8010109c:	c3                   	ret    
8010109d:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010a0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010a3:	89 d8                	mov    %ebx,%eax
801010a5:	75 e9                	jne    80101090 <filewrite+0xd0>
}
801010a7:	83 c4 2c             	add    $0x2c,%esp
801010aa:	5b                   	pop    %ebx
801010ab:	5e                   	pop    %esi
801010ac:	5f                   	pop    %edi
801010ad:	5d                   	pop    %ebp
801010ae:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010af:	8b 47 0c             	mov    0xc(%edi),%eax
801010b2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010b5:	83 c4 2c             	add    $0x2c,%esp
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010bc:	e9 1f 22 00 00       	jmp    801032e0 <pipewrite>
        panic("short filewrite");
801010c1:	c7 04 24 cf 6e 10 80 	movl   $0x80106ecf,(%esp)
801010c8:	e8 93 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010cd:	c7 04 24 d5 6e 10 80 	movl   $0x80106ed5,(%esp)
801010d4:	e8 87 f2 ff ff       	call   80100360 <panic>
801010d9:	66 90                	xchg   %ax,%ax
801010db:	66 90                	xchg   %ax,%ax
801010dd:	66 90                	xchg   %ax,%ax
801010df:	90                   	nop

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 2c             	sub    $0x2c,%esp
801010e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010ec:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801010f1:	85 c0                	test   %eax,%eax
801010f3:	0f 84 8c 00 00 00    	je     80101185 <balloc+0xa5>
801010f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101100:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101103:	89 f0                	mov    %esi,%eax
80101105:	c1 f8 0c             	sar    $0xc,%eax
80101108:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010110e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101112:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101115:	89 04 24             	mov    %eax,(%esp)
80101118:	e8 b3 ef ff ff       	call   801000d0 <bread>
8010111d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101120:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101125:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101128:	31 c0                	xor    %eax,%eax
8010112a:	eb 33                	jmp    8010115f <balloc+0x7f>
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101130:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101133:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101135:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101137:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010113a:	83 e1 07             	and    $0x7,%ecx
8010113d:	bf 01 00 00 00       	mov    $0x1,%edi
80101142:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101144:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101149:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010114b:	0f b6 fb             	movzbl %bl,%edi
8010114e:	85 cf                	test   %ecx,%edi
80101150:	74 46                	je     80101198 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101152:	83 c0 01             	add    $0x1,%eax
80101155:	83 c6 01             	add    $0x1,%esi
80101158:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010115d:	74 05                	je     80101164 <balloc+0x84>
8010115f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101162:	72 cc                	jb     80101130 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101167:	89 04 24             	mov    %eax,(%esp)
8010116a:	e8 71 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010116f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101176:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101179:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010117f:	0f 82 7b ff ff ff    	jb     80101100 <balloc+0x20>
  }
  panic("balloc: out of blocks");
80101185:	c7 04 24 df 6e 10 80 	movl   $0x80106edf,(%esp)
8010118c:	e8 cf f1 ff ff       	call   80100360 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101198:	09 d9                	or     %ebx,%ecx
8010119a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010119d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011a1:	89 1c 24             	mov    %ebx,(%esp)
801011a4:	e8 f7 1a 00 00       	call   80102ca0 <log_write>
        brelse(bp);
801011a9:	89 1c 24             	mov    %ebx,(%esp)
801011ac:	e8 2f f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011b4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011b8:	89 04 24             	mov    %eax,(%esp)
801011bb:	e8 10 ef ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011c0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011c7:	00 
801011c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011cf:	00 
  bp = bread(dev, bno);
801011d0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011d5:	89 04 24             	mov    %eax,(%esp)
801011d8:	e8 d3 30 00 00       	call   801042b0 <memset>
  log_write(bp);
801011dd:	89 1c 24             	mov    %ebx,(%esp)
801011e0:	e8 bb 1a 00 00       	call   80102ca0 <log_write>
  brelse(bp);
801011e5:	89 1c 24             	mov    %ebx,(%esp)
801011e8:	e8 f3 ef ff ff       	call   801001e0 <brelse>
}
801011ed:	83 c4 2c             	add    $0x2c,%esp
801011f0:	89 f0                	mov    %esi,%eax
801011f2:	5b                   	pop    %ebx
801011f3:	5e                   	pop    %esi
801011f4:	5f                   	pop    %edi
801011f5:	5d                   	pop    %ebp
801011f6:	c3                   	ret    
801011f7:	89 f6                	mov    %esi,%esi
801011f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101200 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	89 c7                	mov    %eax,%edi
80101206:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101207:	31 f6                	xor    %esi,%esi
{
80101209:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010120f:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101212:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101219:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010121c:	e8 4f 2f 00 00       	call   80104170 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101224:	eb 14                	jmp    8010123a <iget+0x3a>
80101226:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101228:	85 f6                	test   %esi,%esi
8010122a:	74 3c                	je     80101268 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101232:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101238:	74 46                	je     80101280 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010123a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010123d:	85 c9                	test   %ecx,%ecx
8010123f:	7e e7                	jle    80101228 <iget+0x28>
80101241:	39 3b                	cmp    %edi,(%ebx)
80101243:	75 e3                	jne    80101228 <iget+0x28>
80101245:	39 53 04             	cmp    %edx,0x4(%ebx)
80101248:	75 de                	jne    80101228 <iget+0x28>
      ip->ref++;
8010124a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010124d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010124f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101256:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101259:	e8 02 30 00 00       	call   80104260 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010125e:	83 c4 1c             	add    $0x1c,%esp
80101261:	89 f0                	mov    %esi,%eax
80101263:	5b                   	pop    %ebx
80101264:	5e                   	pop    %esi
80101265:	5f                   	pop    %edi
80101266:	5d                   	pop    %ebp
80101267:	c3                   	ret    
80101268:	85 c9                	test   %ecx,%ecx
8010126a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101273:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101279:	75 bf                	jne    8010123a <iget+0x3a>
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 29                	je     801012ad <iget+0xad>
  ip->dev = dev;
80101284:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101286:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101289:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101290:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101297:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010129e:	e8 bd 2f 00 00       	call   80104260 <release>
}
801012a3:	83 c4 1c             	add    $0x1c,%esp
801012a6:	89 f0                	mov    %esi,%eax
801012a8:	5b                   	pop    %ebx
801012a9:	5e                   	pop    %esi
801012aa:	5f                   	pop    %edi
801012ab:	5d                   	pop    %ebp
801012ac:	c3                   	ret    
    panic("iget: no inodes");
801012ad:	c7 04 24 f5 6e 10 80 	movl   $0x80106ef5,(%esp)
801012b4:	e8 a7 f0 ff ff       	call   80100360 <panic>
801012b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c3                	mov    %eax,%ebx
801012c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012cb:	83 fa 0b             	cmp    $0xb,%edx
801012ce:	77 18                	ja     801012e8 <bmap+0x28>
801012d0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012d3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012d6:	85 c0                	test   %eax,%eax
801012d8:	74 66                	je     80101340 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012da:	83 c4 1c             	add    $0x1c,%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret    
801012e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
801012e8:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801012eb:	83 fe 7f             	cmp    $0x7f,%esi
801012ee:	77 77                	ja     80101367 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
801012f0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 5e                	je     80101358 <bmap+0x98>
    bp = bread(ip->dev, addr);
801012fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801012fe:	8b 03                	mov    (%ebx),%eax
80101300:	89 04 24             	mov    %eax,(%esp)
80101303:	e8 c8 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101308:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
8010130c:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010130e:	8b 32                	mov    (%edx),%esi
80101310:	85 f6                	test   %esi,%esi
80101312:	75 19                	jne    8010132d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101314:	8b 03                	mov    (%ebx),%eax
80101316:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101319:	e8 c2 fd ff ff       	call   801010e0 <balloc>
8010131e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101321:	89 02                	mov    %eax,(%edx)
80101323:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101325:	89 3c 24             	mov    %edi,(%esp)
80101328:	e8 73 19 00 00       	call   80102ca0 <log_write>
    brelse(bp);
8010132d:	89 3c 24             	mov    %edi,(%esp)
80101330:	e8 ab ee ff ff       	call   801001e0 <brelse>
}
80101335:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
80101338:	89 f0                	mov    %esi,%eax
}
8010133a:	5b                   	pop    %ebx
8010133b:	5e                   	pop    %esi
8010133c:	5f                   	pop    %edi
8010133d:	5d                   	pop    %ebp
8010133e:	c3                   	ret    
8010133f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101340:	8b 03                	mov    (%ebx),%eax
80101342:	e8 99 fd ff ff       	call   801010e0 <balloc>
80101347:	89 46 5c             	mov    %eax,0x5c(%esi)
}
8010134a:	83 c4 1c             	add    $0x1c,%esp
8010134d:	5b                   	pop    %ebx
8010134e:	5e                   	pop    %esi
8010134f:	5f                   	pop    %edi
80101350:	5d                   	pop    %ebp
80101351:	c3                   	ret    
80101352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101358:	8b 03                	mov    (%ebx),%eax
8010135a:	e8 81 fd ff ff       	call   801010e0 <balloc>
8010135f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101365:	eb 93                	jmp    801012fa <bmap+0x3a>
  panic("bmap: out of range");
80101367:	c7 04 24 05 6f 10 80 	movl   $0x80106f05,(%esp)
8010136e:	e8 ed ef ff ff       	call   80100360 <panic>
80101373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101380 <readsb>:
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	56                   	push   %esi
80101384:	53                   	push   %ebx
80101385:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
80101388:	8b 45 08             	mov    0x8(%ebp),%eax
8010138b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101392:	00 
{
80101393:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101396:	89 04 24             	mov    %eax,(%esp)
80101399:	e8 32 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010139e:	89 34 24             	mov    %esi,(%esp)
801013a1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013a8:	00 
  bp = bread(dev, 1);
801013a9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013ab:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801013b2:	e8 99 2f 00 00       	call   80104350 <memmove>
  brelse(bp);
801013b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013ba:	83 c4 10             	add    $0x10,%esp
801013bd:	5b                   	pop    %ebx
801013be:	5e                   	pop    %esi
801013bf:	5d                   	pop    %ebp
  brelse(bp);
801013c0:	e9 1b ee ff ff       	jmp    801001e0 <brelse>
801013c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013d0 <bfree>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	89 d7                	mov    %edx,%edi
801013d6:	56                   	push   %esi
801013d7:	53                   	push   %ebx
801013d8:	89 c3                	mov    %eax,%ebx
801013da:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
801013dd:	89 04 24             	mov    %eax,(%esp)
801013e0:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801013e7:	80 
801013e8:	e8 93 ff ff ff       	call   80101380 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013ed:	89 fa                	mov    %edi,%edx
801013ef:	c1 ea 0c             	shr    $0xc,%edx
801013f2:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801013f8:	89 1c 24             	mov    %ebx,(%esp)
  m = 1 << (bi % 8);
801013fb:	bb 01 00 00 00       	mov    $0x1,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101400:	89 54 24 04          	mov    %edx,0x4(%esp)
80101404:	e8 c7 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101409:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
8010140b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101411:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101413:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101416:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101419:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010141b:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
8010141d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101422:	0f b6 c8             	movzbl %al,%ecx
80101425:	85 d9                	test   %ebx,%ecx
80101427:	74 20                	je     80101449 <bfree+0x79>
  bp->data[bi/8] &= ~m;
80101429:	f7 d3                	not    %ebx
8010142b:	21 c3                	and    %eax,%ebx
8010142d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 67 18 00 00       	call   80102ca0 <log_write>
  brelse(bp);
80101439:	89 34 24             	mov    %esi,(%esp)
8010143c:	e8 9f ed ff ff       	call   801001e0 <brelse>
}
80101441:	83 c4 1c             	add    $0x1c,%esp
80101444:	5b                   	pop    %ebx
80101445:	5e                   	pop    %esi
80101446:	5f                   	pop    %edi
80101447:	5d                   	pop    %ebp
80101448:	c3                   	ret    
    panic("freeing free block");
80101449:	c7 04 24 18 6f 10 80 	movl   $0x80106f18,(%esp)
80101450:	e8 0b ef ff ff       	call   80100360 <panic>
80101455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <iinit>:
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101469:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010146c:	c7 44 24 04 2b 6f 10 	movl   $0x80106f2b,0x4(%esp)
80101473:	80 
80101474:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010147b:	e8 00 2c 00 00       	call   80104080 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
80101480:	89 1c 24             	mov    %ebx,(%esp)
80101483:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101489:	c7 44 24 04 32 6f 10 	movl   $0x80106f32,0x4(%esp)
80101490:	80 
80101491:	e8 da 2a 00 00       	call   80103f70 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101496:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010149c:	75 e2                	jne    80101480 <iinit+0x20>
  readsb(dev, &sb);
8010149e:	8b 45 08             	mov    0x8(%ebp),%eax
801014a1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014a8:	80 
801014a9:	89 04 24             	mov    %eax,(%esp)
801014ac:	e8 cf fe ff ff       	call   80101380 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014b1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014b6:	c7 04 24 98 6f 10 80 	movl   $0x80106f98,(%esp)
801014bd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014c1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014c6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ca:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014cf:	89 44 24 14          	mov    %eax,0x14(%esp)
801014d3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014d8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014dc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801014e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014e5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801014ea:	89 44 24 08          	mov    %eax,0x8(%esp)
801014ee:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801014f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f7:	e8 54 f1 ff ff       	call   80100650 <cprintf>
}
801014fc:	83 c4 24             	add    $0x24,%esp
801014ff:	5b                   	pop    %ebx
80101500:	5d                   	pop    %ebp
80101501:	c3                   	ret    
80101502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 2c             	sub    $0x2c,%esp
80101519:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010151c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101523:	8b 7d 08             	mov    0x8(%ebp),%edi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 a2 00 00 00    	jbe    801015d1 <ialloc+0xc1>
8010152f:	be 01 00 00 00       	mov    $0x1,%esi
80101534:	bb 01 00 00 00       	mov    $0x1,%ebx
80101539:	eb 1a                	jmp    80101555 <ialloc+0x45>
8010153b:	90                   	nop
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101540:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	e8 95 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154b:	89 de                	mov    %ebx,%esi
8010154d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101553:	73 7c                	jae    801015d1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101555:	89 f0                	mov    %esi,%eax
80101557:	c1 e8 03             	shr    $0x3,%eax
8010155a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101560:	89 3c 24             	mov    %edi,(%esp)
80101563:	89 44 24 04          	mov    %eax,0x4(%esp)
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 f0                	mov    %esi,%eax
80101570:	83 e0 07             	and    $0x7,%eax
80101573:	c1 e0 06             	shl    $0x6,%eax
80101576:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010157e:	75 c0                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101580:	89 0c 24             	mov    %ecx,(%esp)
80101583:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010158a:	00 
8010158b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101592:	00 
80101593:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	e8 12 2d 00 00       	call   801042b0 <memset>
      dip->type = type;
8010159e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015a5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015ab:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ae:	89 14 24             	mov    %edx,(%esp)
801015b1:	e8 ea 16 00 00       	call   80102ca0 <log_write>
      brelse(bp);
801015b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015b9:	89 14 24             	mov    %edx,(%esp)
801015bc:	e8 1f ec ff ff       	call   801001e0 <brelse>
}
801015c1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015c4:	89 f2                	mov    %esi,%edx
}
801015c6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015c7:	89 f8                	mov    %edi,%eax
}
801015c9:	5e                   	pop    %esi
801015ca:	5f                   	pop    %edi
801015cb:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cc:	e9 2f fc ff ff       	jmp    80101200 <iget>
  panic("ialloc: no inodes");
801015d1:	c7 04 24 38 6f 10 80 	movl   $0x80106f38,(%esp)
801015d8:	e8 83 ed ff ff       	call   80100360 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	83 ec 10             	sub    $0x10,%esp
801015e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801015fe:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101601:	89 04 24             	mov    %eax,(%esp)
80101604:	e8 c7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101609:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010160c:	83 e2 07             	and    $0x7,%edx
8010160f:	c1 e2 06             	shl    $0x6,%edx
80101612:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101616:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101618:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010161f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101623:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101627:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010162b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010162f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101633:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101637:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010163b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010163e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101641:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101645:	89 14 24             	mov    %edx,(%esp)
80101648:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010164f:	00 
80101650:	e8 fb 2c 00 00       	call   80104350 <memmove>
  log_write(bp);
80101655:	89 34 24             	mov    %esi,(%esp)
80101658:	e8 43 16 00 00       	call   80102ca0 <log_write>
  brelse(bp);
8010165d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101660:	83 c4 10             	add    $0x10,%esp
80101663:	5b                   	pop    %ebx
80101664:	5e                   	pop    %esi
80101665:	5d                   	pop    %ebp
  brelse(bp);
80101666:	e9 75 eb ff ff       	jmp    801001e0 <brelse>
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <idup>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	83 ec 14             	sub    $0x14,%esp
80101677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010167a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101681:	e8 ea 2a 00 00       	call   80104170 <acquire>
  ip->ref++;
80101686:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010168a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101691:	e8 ca 2b 00 00       	call   80104260 <release>
}
80101696:	83 c4 14             	add    $0x14,%esp
80101699:	89 d8                	mov    %ebx,%eax
8010169b:	5b                   	pop    %ebx
8010169c:	5d                   	pop    %ebp
8010169d:	c3                   	ret    
8010169e:	66 90                	xchg   %ax,%ax

801016a0 <ilock>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	83 ec 10             	sub    $0x10,%esp
801016a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016ab:	85 db                	test   %ebx,%ebx
801016ad:	0f 84 b3 00 00 00    	je     80101766 <ilock+0xc6>
801016b3:	8b 53 08             	mov    0x8(%ebx),%edx
801016b6:	85 d2                	test   %edx,%edx
801016b8:	0f 8e a8 00 00 00    	jle    80101766 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016be:	8d 43 0c             	lea    0xc(%ebx),%eax
801016c1:	89 04 24             	mov    %eax,(%esp)
801016c4:	e8 e7 28 00 00       	call   80103fb0 <acquiresleep>
  if(ip->valid == 0){
801016c9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016cc:	85 c0                	test   %eax,%eax
801016ce:	74 08                	je     801016d8 <ilock+0x38>
}
801016d0:	83 c4 10             	add    $0x10,%esp
801016d3:	5b                   	pop    %ebx
801016d4:	5e                   	pop    %esi
801016d5:	5d                   	pop    %ebp
801016d6:	c3                   	ret    
801016d7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
801016db:	c1 e8 03             	shr    $0x3,%eax
801016de:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016e8:	8b 03                	mov    (%ebx),%eax
801016ea:	89 04 24             	mov    %eax,(%esp)
801016ed:	e8 de e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f2:	8b 53 04             	mov    0x4(%ebx),%edx
801016f5:	83 e2 07             	and    $0x7,%edx
801016f8:	c1 e2 06             	shl    $0x6,%edx
801016fb:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ff:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101701:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101704:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101707:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010170b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010170f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101713:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101717:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010171b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010171f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101723:	8b 42 fc             	mov    -0x4(%edx),%eax
80101726:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101729:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010172c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101730:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101737:	00 
80101738:	89 04 24             	mov    %eax,(%esp)
8010173b:	e8 10 2c 00 00       	call   80104350 <memmove>
    brelse(bp);
80101740:	89 34 24             	mov    %esi,(%esp)
80101743:	e8 98 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101748:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010174d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101754:	0f 85 76 ff ff ff    	jne    801016d0 <ilock+0x30>
      panic("ilock: no type");
8010175a:	c7 04 24 50 6f 10 80 	movl   $0x80106f50,(%esp)
80101761:	e8 fa eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101766:	c7 04 24 4a 6f 10 80 	movl   $0x80106f4a,(%esp)
8010176d:	e8 ee eb ff ff       	call   80100360 <panic>
80101772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101780 <iunlock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010178b:	85 db                	test   %ebx,%ebx
8010178d:	74 24                	je     801017b3 <iunlock+0x33>
8010178f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101792:	89 34 24             	mov    %esi,(%esp)
80101795:	e8 b6 28 00 00       	call   80104050 <holdingsleep>
8010179a:	85 c0                	test   %eax,%eax
8010179c:	74 15                	je     801017b3 <iunlock+0x33>
8010179e:	8b 43 08             	mov    0x8(%ebx),%eax
801017a1:	85 c0                	test   %eax,%eax
801017a3:	7e 0e                	jle    801017b3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017a5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	5b                   	pop    %ebx
801017ac:	5e                   	pop    %esi
801017ad:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017ae:	e9 5d 28 00 00       	jmp    80104010 <releasesleep>
    panic("iunlock");
801017b3:	c7 04 24 5f 6f 10 80 	movl   $0x80106f5f,(%esp)
801017ba:	e8 a1 eb ff ff       	call   80100360 <panic>
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 1c             	sub    $0x1c,%esp
801017c9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017cc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017cf:	89 3c 24             	mov    %edi,(%esp)
801017d2:	e8 d9 27 00 00       	call   80103fb0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017da:	85 d2                	test   %edx,%edx
801017dc:	74 07                	je     801017e5 <iput+0x25>
801017de:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017e3:	74 2b                	je     80101810 <iput+0x50>
  releasesleep(&ip->lock);
801017e5:	89 3c 24             	mov    %edi,(%esp)
801017e8:	e8 23 28 00 00       	call   80104010 <releasesleep>
  acquire(&icache.lock);
801017ed:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f4:	e8 77 29 00 00       	call   80104170 <acquire>
  ip->ref--;
801017f9:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017fd:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101804:	83 c4 1c             	add    $0x1c,%esp
80101807:	5b                   	pop    %ebx
80101808:	5e                   	pop    %esi
80101809:	5f                   	pop    %edi
8010180a:	5d                   	pop    %ebp
  release(&icache.lock);
8010180b:	e9 50 2a 00 00       	jmp    80104260 <release>
    acquire(&icache.lock);
80101810:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101817:	e8 54 29 00 00       	call   80104170 <acquire>
    int r = ip->ref;
8010181c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010181f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101826:	e8 35 2a 00 00       	call   80104260 <release>
    if(r == 1){
8010182b:	83 fb 01             	cmp    $0x1,%ebx
8010182e:	75 b5                	jne    801017e5 <iput+0x25>
80101830:	8d 4e 30             	lea    0x30(%esi),%ecx
80101833:	89 f3                	mov    %esi,%ebx
80101835:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x87>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fb                	cmp    %edi,%ebx
80101845:	74 19                	je     80101860 <iput+0xa0>
    if(ip->addrs[i]){
80101847:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010184a:	85 d2                	test   %edx,%edx
8010184c:	74 f2                	je     80101840 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010184e:	8b 06                	mov    (%esi),%eax
80101850:	e8 7b fb ff ff       	call   801013d0 <bfree>
      ip->addrs[i] = 0;
80101855:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010185c:	eb e2                	jmp    80101840 <iput+0x80>
8010185e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 2b                	jne    80101898 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010186d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101874:	89 34 24             	mov    %esi,(%esp)
80101877:	e8 64 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010187c:	31 c0                	xor    %eax,%eax
8010187e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101882:	89 34 24             	mov    %esi,(%esp)
80101885:	e8 56 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010188a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101891:	e9 4f ff ff ff       	jmp    801017e5 <iput+0x25>
80101896:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101898:	89 44 24 04          	mov    %eax,0x4(%esp)
8010189c:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
8010189e:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	89 04 24             	mov    %eax,(%esp)
801018a3:	e8 28 e8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018a8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018ab:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018b1:	89 cf                	mov    %ecx,%edi
801018b3:	31 c0                	xor    %eax,%eax
801018b5:	eb 0e                	jmp    801018c5 <iput+0x105>
801018b7:	90                   	nop
801018b8:	83 c3 01             	add    $0x1,%ebx
801018bb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018c1:	89 d8                	mov    %ebx,%eax
801018c3:	74 10                	je     801018d5 <iput+0x115>
      if(a[j])
801018c5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018c8:	85 d2                	test   %edx,%edx
801018ca:	74 ec                	je     801018b8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018cc:	8b 06                	mov    (%esi),%eax
801018ce:	e8 fd fa ff ff       	call   801013d0 <bfree>
801018d3:	eb e3                	jmp    801018b8 <iput+0xf8>
    brelse(bp);
801018d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018db:	89 04 24             	mov    %eax,(%esp)
801018de:	e8 fd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018e3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e9:	8b 06                	mov    (%esi),%eax
801018eb:	e8 e0 fa ff ff       	call   801013d0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f0:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f7:	00 00 00 
801018fa:	e9 6e ff ff ff       	jmp    8010186d <iput+0xad>
801018ff:	90                   	nop

80101900 <iunlockput>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 14             	sub    $0x14,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	89 1c 24             	mov    %ebx,(%esp)
8010190d:	e8 6e fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101912:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101915:	83 c4 14             	add    $0x14,%esp
80101918:	5b                   	pop    %ebx
80101919:	5d                   	pop    %ebp
  iput(ip);
8010191a:	e9 a1 fe ff ff       	jmp    801017c0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 2c             	sub    $0x2c,%esp
80101959:	8b 45 0c             	mov    0xc(%ebp),%eax
8010195c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
80101962:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101965:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101968:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010196d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101970:	0f 84 aa 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101976:	8b 47 58             	mov    0x58(%edi),%eax
80101979:	39 f0                	cmp    %esi,%eax
8010197b:	0f 82 c7 00 00 00    	jb     80101a48 <readi+0xf8>
80101981:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101984:	89 da                	mov    %ebx,%edx
80101986:	01 f2                	add    %esi,%edx
80101988:	0f 82 ba 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010198e:	89 c1                	mov    %eax,%ecx
80101990:	29 f1                	sub    %esi,%ecx
80101992:	39 d0                	cmp    %edx,%eax
80101994:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101997:	31 c0                	xor    %eax,%eax
80101999:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
8010199b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199e:	74 70                	je     80101a10 <readi+0xc0>
801019a0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019a3:	89 c7                	mov    %eax,%edi
801019a5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019ab:	89 f2                	mov    %esi,%edx
801019ad:	c1 ea 09             	shr    $0x9,%edx
801019b0:	89 d8                	mov    %ebx,%eax
801019b2:	e8 09 f9 ff ff       	call   801012c0 <bmap>
801019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019bb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019bd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c2:	89 04 24             	mov    %eax,(%esp)
801019c5:	e8 06 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019cd:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	89 f0                	mov    %esi,%eax
801019d3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019d8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019da:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019de:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019e7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ea:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ee:	01 df                	add    %ebx,%edi
801019f0:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801019f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019f5:	89 04 24             	mov    %eax,(%esp)
801019f8:	e8 53 29 00 00       	call   80104350 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a0e:	77 98                	ja     801019a8 <readi+0x58>
  }
  return n;
80101a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a13:	83 c4 2c             	add    $0x2c,%esp
80101a16:	5b                   	pop    %ebx
80101a17:	5e                   	pop    %esi
80101a18:	5f                   	pop    %edi
80101a19:	5d                   	pop    %ebp
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a35:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a38:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a3b:	83 c4 2c             	add    $0x2c,%esp
80101a3e:	5b                   	pop    %ebx
80101a3f:	5e                   	pop    %esi
80101a40:	5f                   	pop    %edi
80101a41:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a42:	ff e0                	jmp    *%eax
80101a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c4                	jmp    80101a13 <readi+0xc3>
80101a4f:	90                   	nop

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 2c             	sub    $0x2c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a70:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 e3 00 00 00    	jb     80101b68 <writei+0x118>
80101a85:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a88:	89 c8                	mov    %ecx,%eax
80101a8a:	01 f0                	add    %esi,%eax
80101a8c:	0f 82 d6 00 00 00    	jb     80101b68 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a92:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a97:	0f 87 cb 00 00 00    	ja     80101b68 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9d:	85 c9                	test   %ecx,%ecx
80101a9f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa6:	74 77                	je     80101b1f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aab:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aad:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab2:	c1 ea 09             	shr    $0x9,%edx
80101ab5:	89 f8                	mov    %edi,%eax
80101ab7:	e8 04 f8 ff ff       	call   801012c0 <bmap>
80101abc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ac0:	8b 07                	mov    (%edi),%eax
80101ac2:	89 04 24             	mov    %eax,(%esp)
80101ac5:	e8 06 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101acd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ad0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad5:	89 f0                	mov    %esi,%eax
80101ad7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101adc:	29 c3                	sub    %eax,%ebx
80101ade:	39 cb                	cmp    %ecx,%ebx
80101ae0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae7:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101aed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101af1:	89 04 24             	mov    %eax,(%esp)
80101af4:	e8 57 28 00 00       	call   80104350 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 9f 11 00 00       	call   80102ca0 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b0f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b12:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b15:	77 91                	ja     80101aa8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b17:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b1d:	72 39                	jb     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b22:	83 c4 2c             	add    $0x2c,%esp
80101b25:	5b                   	pop    %ebx
80101b26:	5e                   	pop    %esi
80101b27:	5f                   	pop    %edi
80101b28:	5d                   	pop    %ebp
80101b29:	c3                   	ret    
80101b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 2e                	ja     80101b68 <writei+0x118>
80101b3a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 23                	je     80101b68 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b48:	83 c4 2c             	add    $0x2c,%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b5e:	89 04 24             	mov    %eax,(%esp)
80101b61:	e8 7a fa ff ff       	call   801015e0 <iupdate>
80101b66:	eb b7                	jmp    80101b1f <writei+0xcf>
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b70:	5b                   	pop    %ebx
80101b71:	5e                   	pop    %esi
80101b72:	5f                   	pop    %edi
80101b73:	5d                   	pop    %ebp
80101b74:	c3                   	ret    
80101b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b89:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b90:	00 
80101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b95:	8b 45 08             	mov    0x8(%ebp),%eax
80101b98:	89 04 24             	mov    %eax,(%esp)
80101b9b:	e8 30 28 00 00       	call   801043d0 <strncmp>
}
80101ba0:	c9                   	leave  
80101ba1:	c3                   	ret    
80101ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 2c             	sub    $0x2c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 97 00 00 00    	jne    80101c5e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	75 0d                	jne    80101be0 <dirlookup+0x30>
80101bd3:	eb 73                	jmp    80101c48 <dirlookup+0x98>
80101bd5:	8d 76 00             	lea    0x0(%esi),%esi
80101bd8:	83 c7 10             	add    $0x10,%edi
80101bdb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bde:	76 68                	jbe    80101c48 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101be7:	00 
80101be8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bec:	89 74 24 04          	mov    %esi,0x4(%esp)
80101bf0:	89 1c 24             	mov    %ebx,(%esp)
80101bf3:	e8 58 fd ff ff       	call   80101950 <readi>
80101bf8:	83 f8 10             	cmp    $0x10,%eax
80101bfb:	75 55                	jne    80101c52 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c02:	74 d4                	je     80101bd8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c04:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c0e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c15:	00 
80101c16:	89 04 24             	mov    %eax,(%esp)
80101c19:	e8 b2 27 00 00       	call   801043d0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c1e:	85 c0                	test   %eax,%eax
80101c20:	75 b6                	jne    80101bd8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c22:	8b 45 10             	mov    0x10(%ebp),%eax
80101c25:	85 c0                	test   %eax,%eax
80101c27:	74 05                	je     80101c2e <dirlookup+0x7e>
        *poff = off;
80101c29:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c32:	8b 03                	mov    (%ebx),%eax
80101c34:	e8 c7 f5 ff ff       	call   80101200 <iget>
    }
  }

  return 0;
}
80101c39:	83 c4 2c             	add    $0x2c,%esp
80101c3c:	5b                   	pop    %ebx
80101c3d:	5e                   	pop    %esi
80101c3e:	5f                   	pop    %edi
80101c3f:	5d                   	pop    %ebp
80101c40:	c3                   	ret    
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c48:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c4b:	31 c0                	xor    %eax,%eax
}
80101c4d:	5b                   	pop    %ebx
80101c4e:	5e                   	pop    %esi
80101c4f:	5f                   	pop    %edi
80101c50:	5d                   	pop    %ebp
80101c51:	c3                   	ret    
      panic("dirlookup read");
80101c52:	c7 04 24 79 6f 10 80 	movl   $0x80106f79,(%esp)
80101c59:	e8 02 e7 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c5e:	c7 04 24 67 6f 10 80 	movl   $0x80106f67,(%esp)
80101c65:	e8 f6 e6 ff ff       	call   80100360 <panic>
80101c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	89 cf                	mov    %ecx,%edi
80101c76:	56                   	push   %esi
80101c77:	53                   	push   %ebx
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 51 01 00 00    	je     80101dda <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 02 1a 00 00       	call   80103690 <myproc>
80101c8e:	8b 70 70             	mov    0x70(%eax),%esi
  acquire(&icache.lock);
80101c91:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c98:	e8 d3 24 00 00       	call   80104170 <acquire>
  ip->ref++;
80101c9d:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca8:	e8 b3 25 00 00       	call   80104260 <release>
80101cad:	eb 04                	jmp    80101cb3 <namex+0x43>
80101caf:	90                   	nop
    path++;
80101cb0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cb3:	0f b6 03             	movzbl (%ebx),%eax
80101cb6:	3c 2f                	cmp    $0x2f,%al
80101cb8:	74 f6                	je     80101cb0 <namex+0x40>
  if(*path == 0)
80101cba:	84 c0                	test   %al,%al
80101cbc:	0f 84 ed 00 00 00    	je     80101daf <namex+0x13f>
  while(*path != '/' && *path != 0)
80101cc2:	0f b6 03             	movzbl (%ebx),%eax
80101cc5:	89 da                	mov    %ebx,%edx
80101cc7:	84 c0                	test   %al,%al
80101cc9:	0f 84 b1 00 00 00    	je     80101d80 <namex+0x110>
80101ccf:	3c 2f                	cmp    $0x2f,%al
80101cd1:	75 0f                	jne    80101ce2 <namex+0x72>
80101cd3:	e9 a8 00 00 00       	jmp    80101d80 <namex+0x110>
80101cd8:	3c 2f                	cmp    $0x2f,%al
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ce0:	74 0a                	je     80101cec <namex+0x7c>
    path++;
80101ce2:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce5:	0f b6 02             	movzbl (%edx),%eax
80101ce8:	84 c0                	test   %al,%al
80101cea:	75 ec                	jne    80101cd8 <namex+0x68>
80101cec:	89 d1                	mov    %edx,%ecx
80101cee:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf0:	83 f9 0d             	cmp    $0xd,%ecx
80101cf3:	0f 8e 8f 00 00 00    	jle    80101d88 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cf9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101cfd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d04:	00 
80101d05:	89 3c 24             	mov    %edi,(%esp)
80101d08:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d0b:	e8 40 26 00 00       	call   80104350 <memmove>
    path++;
80101d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d13:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d15:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d18:	75 0e                	jne    80101d28 <namex+0xb8>
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	89 34 24             	mov    %esi,(%esp)
80101d2b:	e8 70 f9 ff ff       	call   801016a0 <ilock>
    if(ip->type != T_DIR){
80101d30:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d35:	0f 85 85 00 00 00    	jne    80101dc0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d3e:	85 d2                	test   %edx,%edx
80101d40:	74 09                	je     80101d4b <namex+0xdb>
80101d42:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d45:	0f 84 a5 00 00 00    	je     80101df0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d52:	00 
80101d53:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d57:	89 34 24             	mov    %esi,(%esp)
80101d5a:	e8 51 fe ff ff       	call   80101bb0 <dirlookup>
80101d5f:	85 c0                	test   %eax,%eax
80101d61:	74 5d                	je     80101dc0 <namex+0x150>
  iunlock(ip);
80101d63:	89 34 24             	mov    %esi,(%esp)
80101d66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d69:	e8 12 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	89 c6                	mov    %eax,%esi
80101d7b:	e9 33 ff ff ff       	jmp    80101cb3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101d80:	31 c9                	xor    %ecx,%ecx
80101d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101d88:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d8c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d90:	89 3c 24             	mov    %edi,(%esp)
80101d93:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d96:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d99:	e8 b2 25 00 00       	call   80104350 <memmove>
    name[len] = 0;
80101d9e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101da8:	89 d3                	mov    %edx,%ebx
80101daa:	e9 66 ff ff ff       	jmp    80101d15 <namex+0xa5>
  }
  if(nameiparent){
80101daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101db2:	85 c0                	test   %eax,%eax
80101db4:	75 4c                	jne    80101e02 <namex+0x192>
80101db6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101db8:	83 c4 2c             	add    $0x2c,%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
80101dbf:	c3                   	ret    
  iunlock(ip);
80101dc0:	89 34 24             	mov    %esi,(%esp)
80101dc3:	e8 b8 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101dc8:	89 34 24             	mov    %esi,(%esp)
80101dcb:	e8 f0 f9 ff ff       	call   801017c0 <iput>
}
80101dd0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101dd3:	31 c0                	xor    %eax,%eax
}
80101dd5:	5b                   	pop    %ebx
80101dd6:	5e                   	pop    %esi
80101dd7:	5f                   	pop    %edi
80101dd8:	5d                   	pop    %ebp
80101dd9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dda:	ba 01 00 00 00       	mov    $0x1,%edx
80101ddf:	b8 01 00 00 00       	mov    $0x1,%eax
80101de4:	e8 17 f4 ff ff       	call   80101200 <iget>
80101de9:	89 c6                	mov    %eax,%esi
80101deb:	e9 c3 fe ff ff       	jmp    80101cb3 <namex+0x43>
      iunlock(ip);
80101df0:	89 34 24             	mov    %esi,(%esp)
80101df3:	e8 88 f9 ff ff       	call   80101780 <iunlock>
}
80101df8:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101dfb:	89 f0                	mov    %esi,%eax
}
80101dfd:	5b                   	pop    %ebx
80101dfe:	5e                   	pop    %esi
80101dff:	5f                   	pop    %edi
80101e00:	5d                   	pop    %ebp
80101e01:	c3                   	ret    
    iput(ip);
80101e02:	89 34 24             	mov    %esi,(%esp)
80101e05:	e8 b6 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e0a:	31 c0                	xor    %eax,%eax
80101e0c:	eb aa                	jmp    80101db8 <namex+0x148>
80101e0e:	66 90                	xchg   %ax,%ax

80101e10 <dirlink>:
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 2c             	sub    $0x2c,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e26:	00 
80101e27:	89 1c 24             	mov    %ebx,(%esp)
80101e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e2e:	e8 7d fd ff ff       	call   80101bb0 <dirlookup>
80101e33:	85 c0                	test   %eax,%eax
80101e35:	0f 85 8b 00 00 00    	jne    80101ec6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e3e:	31 ff                	xor    %edi,%edi
80101e40:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e43:	85 c0                	test   %eax,%eax
80101e45:	75 13                	jne    80101e5a <dirlink+0x4a>
80101e47:	eb 35                	jmp    80101e7e <dirlink+0x6e>
80101e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e50:	8d 57 10             	lea    0x10(%edi),%edx
80101e53:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e56:	89 d7                	mov    %edx,%edi
80101e58:	76 24                	jbe    80101e7e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e61:	00 
80101e62:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e66:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e6a:	89 1c 24             	mov    %ebx,(%esp)
80101e6d:	e8 de fa ff ff       	call   80101950 <readi>
80101e72:	83 f8 10             	cmp    $0x10,%eax
80101e75:	75 5e                	jne    80101ed5 <dirlink+0xc5>
    if(de.inum == 0)
80101e77:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7c:	75 d2                	jne    80101e50 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e81:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e88:	00 
80101e89:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e8d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e90:	89 04 24             	mov    %eax,(%esp)
80101e93:	e8 a8 25 00 00       	call   80104440 <strncpy>
  de.inum = inum;
80101e98:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ea2:	00 
80101ea3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ea7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eab:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101eae:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb2:	e8 99 fb ff ff       	call   80101a50 <writei>
80101eb7:	83 f8 10             	cmp    $0x10,%eax
80101eba:	75 25                	jne    80101ee1 <dirlink+0xd1>
  return 0;
80101ebc:	31 c0                	xor    %eax,%eax
}
80101ebe:	83 c4 2c             	add    $0x2c,%esp
80101ec1:	5b                   	pop    %ebx
80101ec2:	5e                   	pop    %esi
80101ec3:	5f                   	pop    %edi
80101ec4:	5d                   	pop    %ebp
80101ec5:	c3                   	ret    
    iput(ip);
80101ec6:	89 04 24             	mov    %eax,(%esp)
80101ec9:	e8 f2 f8 ff ff       	call   801017c0 <iput>
    return -1;
80101ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed3:	eb e9                	jmp    80101ebe <dirlink+0xae>
      panic("dirlink read");
80101ed5:	c7 04 24 88 6f 10 80 	movl   $0x80106f88,(%esp)
80101edc:	e8 7f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101ee1:	c7 04 24 86 75 10 80 	movl   $0x80107586,(%esp)
80101ee8:	e8 73 e4 ff ff       	call   80100360 <panic>
80101eed:	8d 76 00             	lea    0x0(%esi),%esi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	56                   	push   %esi
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	53                   	push   %ebx
80101f37:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f3a:	85 c0                	test   %eax,%eax
80101f3c:	0f 84 99 00 00 00    	je     80101fdb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f42:	8b 48 08             	mov    0x8(%eax),%ecx
80101f45:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f4b:	0f 87 7e 00 00 00    	ja     80101fcf <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f51:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f59:	83 e0 c0             	and    $0xffffffc0,%eax
80101f5c:	3c 40                	cmp    $0x40,%al
80101f5e:	75 f8                	jne    80101f58 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f60:	31 db                	xor    %ebx,%ebx
80101f62:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f67:	89 d8                	mov    %ebx,%eax
80101f69:	ee                   	out    %al,(%dx)
80101f6a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f74:	ee                   	out    %al,(%dx)
80101f75:	0f b6 c1             	movzbl %cl,%eax
80101f78:	b2 f3                	mov    $0xf3,%dl
80101f7a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f7b:	89 c8                	mov    %ecx,%eax
80101f7d:	b2 f4                	mov    $0xf4,%dl
80101f7f:	c1 f8 08             	sar    $0x8,%eax
80101f82:	ee                   	out    %al,(%dx)
80101f83:	b2 f5                	mov    $0xf5,%dl
80101f85:	89 d8                	mov    %ebx,%eax
80101f87:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f88:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8c:	b2 f6                	mov    $0xf6,%dl
80101f8e:	83 e0 01             	and    $0x1,%eax
80101f91:	c1 e0 04             	shl    $0x4,%eax
80101f94:	83 c8 e0             	or     $0xffffffe0,%eax
80101f97:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f98:	f6 06 04             	testb  $0x4,(%esi)
80101f9b:	75 13                	jne    80101fb0 <idestart+0x80>
80101f9d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5d                   	pop    %ebp
80101fae:	c3                   	ret    
80101faf:	90                   	nop
80101fb0:	b2 f7                	mov    $0xf7,%dl
80101fb2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fb7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fb8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fbd:	83 c6 5c             	add    $0x5c,%esi
80101fc0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fc5:	fc                   	cld    
80101fc6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
    panic("incorrect blockno");
80101fcf:	c7 04 24 f4 6f 10 80 	movl   $0x80106ff4,(%esp)
80101fd6:	e8 85 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101fdb:	c7 04 24 eb 6f 10 80 	movl   $0x80106feb,(%esp)
80101fe2:	e8 79 e3 ff ff       	call   80100360 <panic>
80101fe7:	89 f6                	mov    %esi,%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ff0 <ideinit>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80101ff6:	c7 44 24 04 06 70 10 	movl   $0x80107006,0x4(%esp)
80101ffd:	80 
80101ffe:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102005:	e8 76 20 00 00       	call   80104080 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010200a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010200f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102016:	83 e8 01             	sub    $0x1,%eax
80102019:	89 44 24 04          	mov    %eax,0x4(%esp)
8010201d:	e8 7e 02 00 00       	call   801022a0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102022:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102027:	90                   	nop
80102028:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102029:	83 e0 c0             	and    $0xffffffc0,%eax
8010202c:	3c 40                	cmp    $0x40,%al
8010202e:	75 f8                	jne    80102028 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102030:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102035:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203a:	ee                   	out    %al,(%dx)
8010203b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102040:	b2 f7                	mov    $0xf7,%dl
80102042:	eb 09                	jmp    8010204d <ideinit+0x5d>
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102048:	83 e9 01             	sub    $0x1,%ecx
8010204b:	74 0f                	je     8010205c <ideinit+0x6c>
8010204d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010204e:	84 c0                	test   %al,%al
80102050:	74 f6                	je     80102048 <ideinit+0x58>
      havedisk1 = 1;
80102052:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102059:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010205c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102061:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102066:	ee                   	out    %al,(%dx)
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102079:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102080:	e8 eb 20 00 00       	call   80104170 <acquire>

  if((b = idequeue) == 0){
80102085:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010208b:	85 db                	test   %ebx,%ebx
8010208d:	74 30                	je     801020bf <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010208f:	8b 43 58             	mov    0x58(%ebx),%eax
80102092:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102097:	8b 33                	mov    (%ebx),%esi
80102099:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010209f:	74 37                	je     801020d8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020a1:	83 e6 fb             	and    $0xfffffffb,%esi
801020a4:	83 ce 02             	or     $0x2,%esi
801020a7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020a9:	89 1c 24             	mov    %ebx,(%esp)
801020ac:	e8 ff 1c 00 00       	call   80103db0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020b1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020b6:	85 c0                	test   %eax,%eax
801020b8:	74 05                	je     801020bf <ideintr+0x4f>
    idestart(idequeue);
801020ba:	e8 71 fe ff ff       	call   80101f30 <idestart>
    release(&idelock);
801020bf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020c6:	e8 95 21 00 00       	call   80104260 <release>

  release(&idelock);
}
801020cb:	83 c4 1c             	add    $0x1c,%esp
801020ce:	5b                   	pop    %ebx
801020cf:	5e                   	pop    %esi
801020d0:	5f                   	pop    %edi
801020d1:	5d                   	pop    %ebp
801020d2:	c3                   	ret    
801020d3:	90                   	nop
801020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020dd:	8d 76 00             	lea    0x0(%esi),%esi
801020e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c1                	mov    %eax,%ecx
801020e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020e6:	80 f9 40             	cmp    $0x40,%cl
801020e9:	75 f5                	jne    801020e0 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020eb:	a8 21                	test   $0x21,%al
801020ed:	75 b2                	jne    801020a1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
801020ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fc:	fc                   	cld    
801020fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801020ff:	8b 33                	mov    (%ebx),%esi
80102101:	eb 9e                	jmp    801020a1 <ideintr+0x31>
80102103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 14             	sub    $0x14,%esp
80102117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010211a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010211d:	89 04 24             	mov    %eax,(%esp)
80102120:	e8 2b 1f 00 00       	call   80104050 <holdingsleep>
80102125:	85 c0                	test   %eax,%eax
80102127:	0f 84 9e 00 00 00    	je     801021cb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010212d:	8b 03                	mov    (%ebx),%eax
8010212f:	83 e0 06             	and    $0x6,%eax
80102132:	83 f8 02             	cmp    $0x2,%eax
80102135:	0f 84 a8 00 00 00    	je     801021e3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010213b:	8b 53 04             	mov    0x4(%ebx),%edx
8010213e:	85 d2                	test   %edx,%edx
80102140:	74 0d                	je     8010214f <iderw+0x3f>
80102142:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102147:	85 c0                	test   %eax,%eax
80102149:	0f 84 88 00 00 00    	je     801021d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010214f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102156:	e8 15 20 00 00       	call   80104170 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010215b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102160:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102167:	85 c0                	test   %eax,%eax
80102169:	75 07                	jne    80102172 <iderw+0x62>
8010216b:	eb 4e                	jmp    801021bb <iderw+0xab>
8010216d:	8d 76 00             	lea    0x0(%esi),%esi
80102170:	89 d0                	mov    %edx,%eax
80102172:	8b 50 58             	mov    0x58(%eax),%edx
80102175:	85 d2                	test   %edx,%edx
80102177:	75 f7                	jne    80102170 <iderw+0x60>
80102179:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010217c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010217e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102184:	74 3c                	je     801021c2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102186:	8b 03                	mov    (%ebx),%eax
80102188:	83 e0 06             	and    $0x6,%eax
8010218b:	83 f8 02             	cmp    $0x2,%eax
8010218e:	74 1a                	je     801021aa <iderw+0x9a>
    sleep(b, &idelock);
80102190:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102197:	80 
80102198:	89 1c 24             	mov    %ebx,(%esp)
8010219b:	e8 70 1a 00 00       	call   80103c10 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a0:	8b 13                	mov    (%ebx),%edx
801021a2:	83 e2 06             	and    $0x6,%edx
801021a5:	83 fa 02             	cmp    $0x2,%edx
801021a8:	75 e6                	jne    80102190 <iderw+0x80>
  }


  release(&idelock);
801021aa:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021b1:	83 c4 14             	add    $0x14,%esp
801021b4:	5b                   	pop    %ebx
801021b5:	5d                   	pop    %ebp
  release(&idelock);
801021b6:	e9 a5 20 00 00       	jmp    80104260 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021c0:	eb ba                	jmp    8010217c <iderw+0x6c>
    idestart(b);
801021c2:	89 d8                	mov    %ebx,%eax
801021c4:	e8 67 fd ff ff       	call   80101f30 <idestart>
801021c9:	eb bb                	jmp    80102186 <iderw+0x76>
    panic("iderw: buf not locked");
801021cb:	c7 04 24 0a 70 10 80 	movl   $0x8010700a,(%esp)
801021d2:	e8 89 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021d7:	c7 04 24 35 70 10 80 	movl   $0x80107035,(%esp)
801021de:	e8 7d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
801021e3:	c7 04 24 20 70 10 80 	movl   $0x80107020,(%esp)
801021ea:	e8 71 e1 ff ff       	call   80100360 <panic>
801021ef:	90                   	nop

801021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	56                   	push   %esi
801021f4:	53                   	push   %ebx
801021f5:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021f8:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021ff:	00 c0 fe 
  ioapic->reg = reg;
80102202:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102209:	00 00 00 
  return ioapic->data;
8010220c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102212:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102215:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010221b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102221:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102228:	c1 e8 10             	shr    $0x10,%eax
8010222b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010222e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102231:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102234:	39 c2                	cmp    %eax,%edx
80102236:	74 12                	je     8010224a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102238:	c7 04 24 54 70 10 80 	movl   $0x80107054,(%esp)
8010223f:	e8 0c e4 ff ff       	call   80100650 <cprintf>
80102244:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010224a:	ba 10 00 00 00       	mov    $0x10,%edx
8010224f:	31 c0                	xor    %eax,%eax
80102251:	eb 07                	jmp    8010225a <ioapicinit+0x6a>
80102253:	90                   	nop
80102254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102258:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010225a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010225c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102262:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102265:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010226b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010226e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102271:	8d 4a 01             	lea    0x1(%edx),%ecx
80102274:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102277:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102279:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010227f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
80102281:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102288:	7d ce                	jge    80102258 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010228a:	83 c4 10             	add    $0x10,%esp
8010228d:	5b                   	pop    %ebx
8010228e:	5e                   	pop    %esi
8010228f:	5d                   	pop    %ebp
80102290:	c3                   	ret    
80102291:	eb 0d                	jmp    801022a0 <ioapicenable>
80102293:	90                   	nop
80102294:	90                   	nop
80102295:	90                   	nop
80102296:	90                   	nop
80102297:	90                   	nop
80102298:	90                   	nop
80102299:	90                   	nop
8010229a:	90                   	nop
8010229b:	90                   	nop
8010229c:	90                   	nop
8010229d:	90                   	nop
8010229e:	90                   	nop
8010229f:	90                   	nop

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	8b 55 08             	mov    0x8(%ebp),%edx
801022a6:	53                   	push   %ebx
801022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022aa:	8d 5a 20             	lea    0x20(%edx),%ebx
801022ad:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022b1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022ba:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022bc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022c5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022c8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ca:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022d0:	89 42 10             	mov    %eax,0x10(%edx)
}
801022d3:	5b                   	pop    %ebx
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	66 90                	xchg   %ax,%ax
801022d8:	66 90                	xchg   %ax,%ax
801022da:	66 90                	xchg   %ax,%ax
801022dc:	66 90                	xchg   %ax,%ax
801022de:	66 90                	xchg   %ax,%ax

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 14             	sub    $0x14,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 7c                	jne    8010236e <kfree+0x8e>
801022f2:	81 fb f4 59 11 80    	cmp    $0x801159f4,%ebx
801022f8:	72 74                	jb     8010236e <kfree+0x8e>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 67                	ja     8010236e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010230e:	00 
8010230f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102316:	00 
80102317:	89 1c 24             	mov    %ebx,(%esp)
8010231a:	e8 91 1f 00 00       	call   801042b0 <memset>

  if(kmem.use_lock)
8010231f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102325:	85 d2                	test   %edx,%edx
80102327:	75 37                	jne    80102360 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102329:	a1 78 26 11 80       	mov    0x80112678,%eax
8010232e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102330:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102335:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010233b:	85 c0                	test   %eax,%eax
8010233d:	75 09                	jne    80102348 <kfree+0x68>
    release(&kmem.lock);
}
8010233f:	83 c4 14             	add    $0x14,%esp
80102342:	5b                   	pop    %ebx
80102343:	5d                   	pop    %ebp
80102344:	c3                   	ret    
80102345:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102348:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
    release(&kmem.lock);
80102354:	e9 07 1f 00 00       	jmp    80104260 <release>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102360:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102367:	e8 04 1e 00 00       	call   80104170 <acquire>
8010236c:	eb bb                	jmp    80102329 <kfree+0x49>
    panic("kfree");
8010236e:	c7 04 24 86 70 10 80 	movl   $0x80107086,(%esp)
80102375:	e8 e6 df ff ff       	call   80100360 <panic>
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <freerange>:
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102388:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010238b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010238e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102394:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023a0:	39 de                	cmp    %ebx,%esi
801023a2:	73 08                	jae    801023ac <freerange+0x2c>
801023a4:	eb 18                	jmp    801023be <freerange+0x3e>
801023a6:	66 90                	xchg   %ax,%ax
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ac:	89 14 24             	mov    %edx,(%esp)
801023af:	e8 2c ff ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ba:	39 f0                	cmp    %esi,%eax
801023bc:	76 ea                	jbe    801023a8 <freerange+0x28>
}
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	5b                   	pop    %ebx
801023c2:	5e                   	pop    %esi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <kinit1>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	83 ec 10             	sub    $0x10,%esp
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023db:	c7 44 24 04 8c 70 10 	movl   $0x8010708c,0x4(%esp)
801023e2:	80 
801023e3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023ea:	e8 91 1c 00 00       	call   80104080 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
801023f2:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023f9:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801023fc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102402:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102408:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010240e:	39 de                	cmp    %ebx,%esi
80102410:	73 0a                	jae    8010241c <kinit1+0x4c>
80102412:	eb 1a                	jmp    8010242e <kinit1+0x5e>
80102414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102418:	89 da                	mov    %ebx,%edx
8010241a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010241c:	89 14 24             	mov    %edx,(%esp)
8010241f:	e8 bc fe ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102424:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010242a:	39 c6                	cmp    %eax,%esi
8010242c:	73 ea                	jae    80102418 <kinit1+0x48>
}
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010244b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010244e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102454:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 08                	jae    8010246c <kinit2+0x2c>
80102464:	eb 18                	jmp    8010247e <kinit2+0x3e>
80102466:	66 90                	xchg   %ax,%ax
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 6c fe ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 c6                	cmp    %eax,%esi
8010247c:	73 ea                	jae    80102468 <kinit2+0x28>
  kmem.use_lock = 1;
8010247e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102485:	00 00 00 
}
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5d                   	pop    %ebp
8010248e:	c3                   	ret    
8010248f:	90                   	nop

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 74 26 11 80       	mov    0x80112674,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 08                	je     801024b2 <kalloc+0x22>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 0c                	je     801024c2 <kalloc+0x32>
    release(&kmem.lock);
801024b6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024bd:	e8 9e 1d 00 00       	call   80104260 <release>
  return (char*)r;
}
801024c2:	83 c4 14             	add    $0x14,%esp
801024c5:	89 d8                	mov    %ebx,%eax
801024c7:	5b                   	pop    %ebx
801024c8:	5d                   	pop    %ebp
801024c9:	c3                   	ret    
801024ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024d0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024d7:	e8 94 1c 00 00       	call   80104170 <acquire>
801024dc:	a1 74 26 11 80       	mov    0x80112674,%eax
801024e1:	eb bd                	jmp    801024a0 <kalloc+0x10>
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f0:	ba 64 00 00 00       	mov    $0x64,%edx
801024f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f6:	a8 01                	test   $0x1,%al
801024f8:	0f 84 ba 00 00 00    	je     801025b8 <kbdgetc+0xc8>
801024fe:	b2 60                	mov    $0x60,%dl
80102500:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102501:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102504:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010250a:	0f 84 88 00 00 00    	je     80102598 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102510:	84 c0                	test   %al,%al
80102512:	79 2c                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010251a:	f6 c2 40             	test   $0x40,%dl
8010251d:	75 05                	jne    80102524 <kbdgetc+0x34>
8010251f:	89 c1                	mov    %eax,%ecx
80102521:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102524:	0f b6 81 c0 71 10 80 	movzbl -0x7fef8e40(%ecx),%eax
8010252b:	83 c8 40             	or     $0x40,%eax
8010252e:	0f b6 c0             	movzbl %al,%eax
80102531:	f7 d0                	not    %eax
80102533:	21 d0                	and    %edx,%eax
80102535:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253a:	31 c0                	xor    %eax,%eax
8010253c:	c3                   	ret    
8010253d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010254a:	f6 c3 40             	test   $0x40,%bl
8010254d:	74 09                	je     80102558 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102552:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102555:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102558:	0f b6 91 c0 71 10 80 	movzbl -0x7fef8e40(%ecx),%edx
  shift ^= togglecode[data];
8010255f:	0f b6 81 c0 70 10 80 	movzbl -0x7fef8f40(%ecx),%eax
  shift |= shiftcode[data];
80102566:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102568:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010256a:	89 d0                	mov    %edx,%eax
8010256c:	83 e0 03             	and    $0x3,%eax
8010256f:	8b 04 85 a0 70 10 80 	mov    -0x7fef8f60(,%eax,4),%eax
  shift ^= togglecode[data];
80102576:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
8010257c:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010257f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102583:	74 0b                	je     80102590 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102585:	8d 50 9f             	lea    -0x61(%eax),%edx
80102588:	83 fa 19             	cmp    $0x19,%edx
8010258b:	77 1b                	ja     801025a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010258d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102590:	5b                   	pop    %ebx
80102591:	5d                   	pop    %ebp
80102592:	c3                   	ret    
80102593:	90                   	nop
80102594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102598:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010259f:	31 c0                	xor    %eax,%eax
801025a1:	c3                   	ret    
801025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025ab:	8d 50 20             	lea    0x20(%eax),%edx
801025ae:	83 f9 19             	cmp    $0x19,%ecx
801025b1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025b4:	eb da                	jmp    80102590 <kbdgetc+0xa0>
801025b6:	66 90                	xchg   %ax,%ax
    return -1;
801025b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax

801025c0 <kbdintr>:

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025c6:	c7 04 24 f0 24 10 80 	movl   $0x801024f0,(%esp)
801025cd:	e8 de e1 ff ff       	call   801007b0 <consoleintr>
}
801025d2:	c9                   	leave  
801025d3:	c3                   	ret    
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025e0:	55                   	push   %ebp
801025e1:	89 c1                	mov    %eax,%ecx
801025e3:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e5:	ba 70 00 00 00       	mov    $0x70,%edx
801025ea:	53                   	push   %ebx
801025eb:	31 c0                	xor    %eax,%eax
801025ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ee:	bb 71 00 00 00       	mov    $0x71,%ebx
801025f3:	89 da                	mov    %ebx,%edx
801025f5:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
801025f6:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f9:	b2 70                	mov    $0x70,%dl
801025fb:	89 01                	mov    %eax,(%ecx)
801025fd:	b8 02 00 00 00       	mov    $0x2,%eax
80102602:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
80102606:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 41 04             	mov    %eax,0x4(%ecx)
8010260e:	b8 04 00 00 00       	mov    $0x4,%eax
80102613:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102614:	89 da                	mov    %ebx,%edx
80102616:	ec                   	in     (%dx),%al
80102617:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261a:	b2 70                	mov    $0x70,%dl
8010261c:	89 41 08             	mov    %eax,0x8(%ecx)
8010261f:	b8 07 00 00 00       	mov    $0x7,%eax
80102624:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102625:	89 da                	mov    %ebx,%edx
80102627:	ec                   	in     (%dx),%al
80102628:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262b:	b2 70                	mov    $0x70,%dl
8010262d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102630:	b8 08 00 00 00       	mov    $0x8,%eax
80102635:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102636:	89 da                	mov    %ebx,%edx
80102638:	ec                   	in     (%dx),%al
80102639:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263c:	b2 70                	mov    $0x70,%dl
8010263e:	89 41 10             	mov    %eax,0x10(%ecx)
80102641:	b8 09 00 00 00       	mov    $0x9,%eax
80102646:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102647:	89 da                	mov    %ebx,%edx
80102649:	ec                   	in     (%dx),%al
8010264a:	0f b6 d8             	movzbl %al,%ebx
8010264d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102650:	5b                   	pop    %ebx
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret    
80102653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <lapicinit>:
  if(!lapic)
80102660:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c0 00 00 00    	je     80102730 <lapicinit+0xd0>
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 6f                	ja     80102738 <lapicinit+0xd8>
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102718:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010271e:	80 e6 10             	and    $0x10,%dh
80102721:	75 f5                	jne    80102718 <lapicinit+0xb8>
  lapic[index] = value;
80102723:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102730:	5d                   	pop    %ebp
80102731:	c3                   	ret    
80102732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102738:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010273f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102742:	8b 50 20             	mov    0x20(%eax),%edx
80102745:	eb 82                	jmp    801026c9 <lapicinit+0x69>
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicid>:
  if (!lapic)
80102750:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0c                	je     80102768 <lapicid+0x18>
  return lapic[ID] >> 24;
8010275c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010275f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102760:	c1 e8 18             	shr    $0x18,%eax
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102768:	31 c0                	xor    %eax,%eax
}
8010276a:	5d                   	pop    %ebp
8010276b:	c3                   	ret    
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <lapiceoi>:
  if(lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0d                	je     80102789 <lapiceoi+0x19>
  lapic[index] = value;
8010277c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102783:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 40 20             	mov    0x20(%eax),%eax
}
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <microdelay>:
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
}
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicstartap>:
{
801027a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	ba 70 00 00 00       	mov    $0x70,%edx
801027a6:	89 e5                	mov    %esp,%ebp
801027a8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027ad:	53                   	push   %ebx
801027ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027b4:	ee                   	out    %al,(%dx)
801027b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ba:	b2 71                	mov    $0x71,%dl
801027bc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027bd:	31 c0                	xor    %eax,%eax
801027bf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027c5:	89 d8                	mov    %ebx,%eax
801027c7:	c1 e8 04             	shr    $0x4,%eax
801027ca:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
801027d5:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027d8:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
801027db:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027eb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fe:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102807:	89 da                	mov    %ebx,%edx
80102809:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010280c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102812:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102815:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010281e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 40 20             	mov    0x20(%eax),%eax
}
80102827:	5b                   	pop    %ebx
80102828:	5d                   	pop    %ebp
80102829:	c3                   	ret    
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102830 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	ba 70 00 00 00       	mov    $0x70,%edx
80102836:	89 e5                	mov    %esp,%ebp
80102838:	b8 0b 00 00 00       	mov    $0xb,%eax
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 4c             	sub    $0x4c,%esp
80102843:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	b2 71                	mov    $0x71,%dl
80102846:	ec                   	in     (%dx),%al
80102847:	88 45 b7             	mov    %al,-0x49(%ebp)
8010284a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010284d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102851:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010285d:	89 d8                	mov    %ebx,%eax
8010285f:	e8 7c fd ff ff       	call   801025e0 <fill_rtcdate>
80102864:	b8 0a 00 00 00       	mov    $0xa,%eax
80102869:	89 f2                	mov    %esi,%edx
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	ba 71 00 00 00       	mov    $0x71,%edx
80102871:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102872:	84 c0                	test   %al,%al
80102874:	78 e7                	js     8010285d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102876:	89 f8                	mov    %edi,%eax
80102878:	e8 63 fd ff ff       	call   801025e0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010287d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102884:	00 
80102885:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102889:	89 1c 24             	mov    %ebx,(%esp)
8010288c:	e8 6f 1a 00 00       	call   80104300 <memcmp>
80102891:	85 c0                	test   %eax,%eax
80102893:	75 c3                	jne    80102858 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102895:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102899:	75 78                	jne    80102913 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010289b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010289e:	89 c2                	mov    %eax,%edx
801028a0:	83 e0 0f             	and    $0xf,%eax
801028a3:	c1 ea 04             	shr    $0x4,%edx
801028a6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028a9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028ac:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028af:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028b2:	89 c2                	mov    %eax,%edx
801028b4:	83 e0 0f             	and    $0xf,%eax
801028b7:	c1 ea 04             	shr    $0x4,%edx
801028ba:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028bd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028c0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028c6:	89 c2                	mov    %eax,%edx
801028c8:	83 e0 0f             	and    $0xf,%eax
801028cb:	c1 ea 04             	shr    $0x4,%edx
801028ce:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028d1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028da:	89 c2                	mov    %eax,%edx
801028dc:	83 e0 0f             	and    $0xf,%eax
801028df:	c1 ea 04             	shr    $0x4,%edx
801028e2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028ee:	89 c2                	mov    %eax,%edx
801028f0:	83 e0 0f             	and    $0xf,%eax
801028f3:	c1 ea 04             	shr    $0x4,%edx
801028f6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801028ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102902:	89 c2                	mov    %eax,%edx
80102904:	83 e0 0f             	and    $0xf,%eax
80102907:	c1 ea 04             	shr    $0x4,%edx
8010290a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010290d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102910:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102913:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102916:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102919:	89 01                	mov    %eax,(%ecx)
8010291b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010291e:	89 41 04             	mov    %eax,0x4(%ecx)
80102921:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102924:	89 41 08             	mov    %eax,0x8(%ecx)
80102927:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010292a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010292d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102930:	89 41 10             	mov    %eax,0x10(%ecx)
80102933:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102936:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102939:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102940:	83 c4 4c             	add    $0x4c,%esp
80102943:	5b                   	pop    %ebx
80102944:	5e                   	pop    %esi
80102945:	5f                   	pop    %edi
80102946:	5d                   	pop    %ebp
80102947:	c3                   	ret    
80102948:	66 90                	xchg   %ax,%ax
8010294a:	66 90                	xchg   %ax,%ax
8010294c:	66 90                	xchg   %ax,%ax
8010294e:	66 90                	xchg   %ax,%ax

80102950 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102950:	55                   	push   %ebp
80102951:	89 e5                	mov    %esp,%ebp
80102953:	57                   	push   %edi
80102954:	56                   	push   %esi
80102955:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102956:	31 db                	xor    %ebx,%ebx
{
80102958:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010295b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102960:	85 c0                	test   %eax,%eax
80102962:	7e 78                	jle    801029dc <install_trans+0x8c>
80102964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102968:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010296d:	01 d8                	add    %ebx,%eax
8010296f:	83 c0 01             	add    $0x1,%eax
80102972:	89 44 24 04          	mov    %eax,0x4(%esp)
80102976:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010297b:	89 04 24             	mov    %eax,(%esp)
8010297e:	e8 4d d7 ff ff       	call   801000d0 <bread>
80102983:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102985:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
8010298c:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010298f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102993:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102998:	89 04 24             	mov    %eax,(%esp)
8010299b:	e8 30 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029a0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029a7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029a8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029aa:	8d 47 5c             	lea    0x5c(%edi),%eax
801029ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029b4:	89 04 24             	mov    %eax,(%esp)
801029b7:	e8 94 19 00 00       	call   80104350 <memmove>
    bwrite(dbuf);  // write dst to disk
801029bc:	89 34 24             	mov    %esi,(%esp)
801029bf:	e8 dc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029c4:	89 3c 24             	mov    %edi,(%esp)
801029c7:	e8 14 d8 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029cc:	89 34 24             	mov    %esi,(%esp)
801029cf:	e8 0c d8 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029d4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029da:	7f 8c                	jg     80102968 <install_trans+0x18>
  }
}
801029dc:	83 c4 1c             	add    $0x1c,%esp
801029df:	5b                   	pop    %ebx
801029e0:	5e                   	pop    %esi
801029e1:	5f                   	pop    %edi
801029e2:	5d                   	pop    %ebp
801029e3:	c3                   	ret    
801029e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801029f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	57                   	push   %edi
801029f4:	56                   	push   %esi
801029f5:	53                   	push   %ebx
801029f6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
801029f9:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a02:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a07:	89 04 24             	mov    %eax,(%esp)
80102a0a:	e8 c1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a0f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a15:	31 d2                	xor    %edx,%edx
80102a17:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a19:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a1b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a1e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a21:	7e 17                	jle    80102a3a <write_head+0x4a>
80102a23:	90                   	nop
80102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a28:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a2f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a33:	83 c2 01             	add    $0x1,%edx
80102a36:	39 da                	cmp    %ebx,%edx
80102a38:	75 ee                	jne    80102a28 <write_head+0x38>
  }
  bwrite(buf);
80102a3a:	89 3c 24             	mov    %edi,(%esp)
80102a3d:	e8 5e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a42:	89 3c 24             	mov    %edi,(%esp)
80102a45:	e8 96 d7 ff ff       	call   801001e0 <brelse>
}
80102a4a:	83 c4 1c             	add    $0x1c,%esp
80102a4d:	5b                   	pop    %ebx
80102a4e:	5e                   	pop    %esi
80102a4f:	5f                   	pop    %edi
80102a50:	5d                   	pop    %ebp
80102a51:	c3                   	ret    
80102a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <initlog>:
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	56                   	push   %esi
80102a64:	53                   	push   %ebx
80102a65:	83 ec 30             	sub    $0x30,%esp
80102a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a6b:	c7 44 24 04 c0 72 10 	movl   $0x801072c0,0x4(%esp)
80102a72:	80 
80102a73:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a7a:	e8 01 16 00 00       	call   80104080 <initlock>
  readsb(dev, &sb);
80102a7f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a82:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a86:	89 1c 24             	mov    %ebx,(%esp)
80102a89:	e8 f2 e8 ff ff       	call   80101380 <readsb>
  log.start = sb.logstart;
80102a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102a91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102a94:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102a97:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102aa1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102aa7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102aac:	e8 1f d6 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ab1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102ab3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ab6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ab9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102abb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ac1:	7e 17                	jle    80102ada <initlog+0x7a>
80102ac3:	90                   	nop
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ac8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102acc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ad3:	83 c2 01             	add    $0x1,%edx
80102ad6:	39 da                	cmp    %ebx,%edx
80102ad8:	75 ee                	jne    80102ac8 <initlog+0x68>
  brelse(buf);
80102ada:	89 04 24             	mov    %eax,(%esp)
80102add:	e8 fe d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ae2:	e8 69 fe ff ff       	call   80102950 <install_trans>
  log.lh.n = 0;
80102ae7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102aee:	00 00 00 
  write_head(); // clear the log
80102af1:	e8 fa fe ff ff       	call   801029f0 <write_head>
}
80102af6:	83 c4 30             	add    $0x30,%esp
80102af9:	5b                   	pop    %ebx
80102afa:	5e                   	pop    %esi
80102afb:	5d                   	pop    %ebp
80102afc:	c3                   	ret    
80102afd:	8d 76 00             	lea    0x0(%esi),%esi

80102b00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b06:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b0d:	e8 5e 16 00 00       	call   80104170 <acquire>
80102b12:	eb 18                	jmp    80102b2c <begin_op+0x2c>
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b18:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b1f:	80 
80102b20:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b27:	e8 e4 10 00 00       	call   80103c10 <sleep>
    if(log.committing){
80102b2c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b31:	85 c0                	test   %eax,%eax
80102b33:	75 e3                	jne    80102b18 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b35:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b3a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b40:	83 c0 01             	add    $0x1,%eax
80102b43:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b46:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b49:	83 fa 1e             	cmp    $0x1e,%edx
80102b4c:	7f ca                	jg     80102b18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b4e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b55:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b5a:	e8 01 17 00 00       	call   80104260 <release>
      break;
    }
  }
}
80102b5f:	c9                   	leave  
80102b60:	c3                   	ret    
80102b61:	eb 0d                	jmp    80102b70 <end_op>
80102b63:	90                   	nop
80102b64:	90                   	nop
80102b65:	90                   	nop
80102b66:	90                   	nop
80102b67:	90                   	nop
80102b68:	90                   	nop
80102b69:	90                   	nop
80102b6a:	90                   	nop
80102b6b:	90                   	nop
80102b6c:	90                   	nop
80102b6d:	90                   	nop
80102b6e:	90                   	nop
80102b6f:	90                   	nop

80102b70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	57                   	push   %edi
80102b74:	56                   	push   %esi
80102b75:	53                   	push   %ebx
80102b76:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b79:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b80:	e8 eb 15 00 00       	call   80104170 <acquire>
  log.outstanding -= 1;
80102b85:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102b8a:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102b90:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102b93:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102b95:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102b9a:	0f 85 f3 00 00 00    	jne    80102c93 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102ba0:	85 c0                	test   %eax,%eax
80102ba2:	0f 85 cb 00 00 00    	jne    80102c73 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ba8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102baf:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102bb1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bb8:	00 00 00 
  release(&log.lock);
80102bbb:	e8 a0 16 00 00       	call   80104260 <release>
  if (log.lh.n > 0) {
80102bc0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bc5:	85 c0                	test   %eax,%eax
80102bc7:	0f 8e 90 00 00 00    	jle    80102c5d <end_op+0xed>
80102bcd:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bd0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bd5:	01 d8                	add    %ebx,%eax
80102bd7:	83 c0 01             	add    $0x1,%eax
80102bda:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bde:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102be3:	89 04 24             	mov    %eax,(%esp)
80102be6:	e8 e5 d4 ff ff       	call   801000d0 <bread>
80102beb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bed:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102bf4:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bfb:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c00:	89 04 24             	mov    %eax,(%esp)
80102c03:	e8 c8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c08:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c0f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c10:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c12:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c15:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c19:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1c:	89 04 24             	mov    %eax,(%esp)
80102c1f:	e8 2c 17 00 00       	call   80104350 <memmove>
    bwrite(to);  // write the log
80102c24:	89 34 24             	mov    %esi,(%esp)
80102c27:	e8 74 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c2c:	89 3c 24             	mov    %edi,(%esp)
80102c2f:	e8 ac d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c34:	89 34 24             	mov    %esi,(%esp)
80102c37:	e8 a4 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c3c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c42:	7c 8c                	jl     80102bd0 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c44:	e8 a7 fd ff ff       	call   801029f0 <write_head>
    install_trans(); // Now install writes to home locations
80102c49:	e8 02 fd ff ff       	call   80102950 <install_trans>
    log.lh.n = 0;
80102c4e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c55:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c58:	e8 93 fd ff ff       	call   801029f0 <write_head>
    acquire(&log.lock);
80102c5d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c64:	e8 07 15 00 00       	call   80104170 <acquire>
    log.committing = 0;
80102c69:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c70:	00 00 00 
    wakeup(&log);
80102c73:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c7a:	e8 31 11 00 00       	call   80103db0 <wakeup>
    release(&log.lock);
80102c7f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c86:	e8 d5 15 00 00       	call   80104260 <release>
}
80102c8b:	83 c4 1c             	add    $0x1c,%esp
80102c8e:	5b                   	pop    %ebx
80102c8f:	5e                   	pop    %esi
80102c90:	5f                   	pop    %edi
80102c91:	5d                   	pop    %ebp
80102c92:	c3                   	ret    
    panic("log.committing");
80102c93:	c7 04 24 c4 72 10 80 	movl   $0x801072c4,(%esp)
80102c9a:	e8 c1 d6 ff ff       	call   80100360 <panic>
80102c9f:	90                   	nop

80102ca0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ca7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102cac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102caf:	83 f8 1d             	cmp    $0x1d,%eax
80102cb2:	0f 8f 98 00 00 00    	jg     80102d50 <log_write+0xb0>
80102cb8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cbe:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cc1:	39 d0                	cmp    %edx,%eax
80102cc3:	0f 8d 87 00 00 00    	jge    80102d50 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cc9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cce:	85 c0                	test   %eax,%eax
80102cd0:	0f 8e 86 00 00 00    	jle    80102d5c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cd6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cdd:	e8 8e 14 00 00       	call   80104170 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ce2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ce8:	83 fa 00             	cmp    $0x0,%edx
80102ceb:	7e 54                	jle    80102d41 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ced:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102cf0:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102cf2:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102cf8:	75 0f                	jne    80102d09 <log_write+0x69>
80102cfa:	eb 3c                	jmp    80102d38 <log_write+0x98>
80102cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d00:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d07:	74 2f                	je     80102d38 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d09:	83 c0 01             	add    $0x1,%eax
80102d0c:	39 d0                	cmp    %edx,%eax
80102d0e:	75 f0                	jne    80102d00 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d10:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d17:	83 c2 01             	add    $0x1,%edx
80102d1a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d20:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d23:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d2a:	83 c4 14             	add    $0x14,%esp
80102d2d:	5b                   	pop    %ebx
80102d2e:	5d                   	pop    %ebp
  release(&log.lock);
80102d2f:	e9 2c 15 00 00       	jmp    80104260 <release>
80102d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d38:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d3f:	eb df                	jmp    80102d20 <log_write+0x80>
80102d41:	8b 43 08             	mov    0x8(%ebx),%eax
80102d44:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d49:	75 d5                	jne    80102d20 <log_write+0x80>
80102d4b:	eb ca                	jmp    80102d17 <log_write+0x77>
80102d4d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d50:	c7 04 24 d3 72 10 80 	movl   $0x801072d3,(%esp)
80102d57:	e8 04 d6 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d5c:	c7 04 24 e9 72 10 80 	movl   $0x801072e9,(%esp)
80102d63:	e8 f8 d5 ff ff       	call   80100360 <panic>
80102d68:	66 90                	xchg   %ax,%ax
80102d6a:	66 90                	xchg   %ax,%ax
80102d6c:	66 90                	xchg   %ax,%ax
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d77:	e8 f4 08 00 00       	call   80103670 <cpuid>
80102d7c:	89 c3                	mov    %eax,%ebx
80102d7e:	e8 ed 08 00 00       	call   80103670 <cpuid>
80102d83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d87:	c7 04 24 04 73 10 80 	movl   $0x80107304,(%esp)
80102d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d92:	e8 b9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102d97:	e8 94 27 00 00       	call   80105530 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102d9c:	e8 4f 08 00 00       	call   801035f0 <mycpu>
80102da1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102da3:	b8 01 00 00 00       	mov    $0x1,%eax
80102da8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102daf:	e8 ac 0b 00 00       	call   80103960 <scheduler>
80102db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102dc0 <mpenter>:
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102dc6:	e8 25 38 00 00       	call   801065f0 <switchkvm>
  seginit();
80102dcb:	e8 e0 36 00 00       	call   801064b0 <seginit>
  lapicinit();
80102dd0:	e8 8b f8 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102dd5:	e8 96 ff ff ff       	call   80102d70 <mpmain>
80102dda:	66 90                	xchg   %ax,%ax
80102ddc:	66 90                	xchg   %ax,%ax
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <main>:
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102de4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102de9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dec:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102def:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102df6:	80 
80102df7:	c7 04 24 f4 59 11 80 	movl   $0x801159f4,(%esp)
80102dfe:	e8 cd f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e03:	e8 98 3c 00 00       	call   80106aa0 <kvmalloc>
  mpinit();        // detect other processors
80102e08:	e8 73 01 00 00       	call   80102f80 <mpinit>
80102e0d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e10:	e8 4b f8 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102e15:	e8 96 36 00 00       	call   801064b0 <seginit>
  picinit();       // disable pic
80102e1a:	e8 21 03 00 00       	call   80103140 <picinit>
80102e1f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e20:	e8 cb f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102e25:	e8 26 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e2a:	e8 21 2a 00 00       	call   80105850 <uartinit>
80102e2f:	90                   	nop
  pinit();         // process table
80102e30:	e8 9b 07 00 00       	call   801035d0 <pinit>
  shminit();       // shared memory
80102e35:	e8 56 3f 00 00       	call   80106d90 <shminit>
  tvinit();        // trap vectors
80102e3a:	e8 51 26 00 00       	call   80105490 <tvinit>
80102e3f:	90                   	nop
  binit();         // buffer cache
80102e40:	e8 fb d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e45:	e8 e6 de ff ff       	call   80100d30 <fileinit>
  ideinit();       // disk 
80102e4a:	e8 a1 f1 ff ff       	call   80101ff0 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e4f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e56:	00 
80102e57:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e5e:	80 
80102e5f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e66:	e8 e5 14 00 00       	call   80104350 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e6b:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e72:	00 00 00 
80102e75:	05 80 27 11 80       	add    $0x80112780,%eax
80102e7a:	39 d8                	cmp    %ebx,%eax
80102e7c:	76 65                	jbe    80102ee3 <main+0x103>
80102e7e:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102e80:	e8 6b 07 00 00       	call   801035f0 <mycpu>
80102e85:	39 d8                	cmp    %ebx,%eax
80102e87:	74 41                	je     80102eca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e89:	e8 02 f6 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102e8e:	c7 05 f8 6f 00 80 c0 	movl   $0x80102dc0,0x80006ff8
80102e95:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e98:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e9f:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ea2:	05 00 10 00 00       	add    $0x1000,%eax
80102ea7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102eac:	0f b6 03             	movzbl (%ebx),%eax
80102eaf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102eb6:	00 
80102eb7:	89 04 24             	mov    %eax,(%esp)
80102eba:	e8 e1 f8 ff ff       	call   801027a0 <lapicstartap>
80102ebf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ec0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ec6:	85 c0                	test   %eax,%eax
80102ec8:	74 f6                	je     80102ec0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102eca:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ed1:	00 00 00 
80102ed4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eda:	05 80 27 11 80       	add    $0x80112780,%eax
80102edf:	39 c3                	cmp    %eax,%ebx
80102ee1:	72 9d                	jb     80102e80 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ee3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102eea:	8e 
80102eeb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102ef2:	e8 49 f5 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80102ef7:	e8 c4 07 00 00       	call   801036c0 <userinit>
  mpmain();        // finish this processor's setup
80102efc:	e8 6f fe ff ff       	call   80102d70 <mpmain>
80102f01:	66 90                	xchg   %ax,%ax
80102f03:	66 90                	xchg   %ax,%ax
80102f05:	66 90                	xchg   %ax,%ax
80102f07:	66 90                	xchg   %ax,%ax
80102f09:	66 90                	xchg   %ax,%ax
80102f0b:	66 90                	xchg   %ax,%ax
80102f0d:	66 90                	xchg   %ax,%ax
80102f0f:	90                   	nop

80102f10 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f14:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f1a:	53                   	push   %ebx
  e = addr+len;
80102f1b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f1e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f21:	39 de                	cmp    %ebx,%esi
80102f23:	73 3c                	jae    80102f61 <mpsearch1+0x51>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f28:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f2f:	00 
80102f30:	c7 44 24 04 18 73 10 	movl   $0x80107318,0x4(%esp)
80102f37:	80 
80102f38:	89 34 24             	mov    %esi,(%esp)
80102f3b:	e8 c0 13 00 00       	call   80104300 <memcmp>
80102f40:	85 c0                	test   %eax,%eax
80102f42:	75 16                	jne    80102f5a <mpsearch1+0x4a>
80102f44:	31 c9                	xor    %ecx,%ecx
80102f46:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f48:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f4c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f4f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f51:	83 fa 10             	cmp    $0x10,%edx
80102f54:	75 f2                	jne    80102f48 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f56:	84 c9                	test   %cl,%cl
80102f58:	74 10                	je     80102f6a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f5a:	83 c6 10             	add    $0x10,%esi
80102f5d:	39 f3                	cmp    %esi,%ebx
80102f5f:	77 c7                	ja     80102f28 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f61:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f64:	31 c0                	xor    %eax,%eax
}
80102f66:	5b                   	pop    %ebx
80102f67:	5e                   	pop    %esi
80102f68:	5d                   	pop    %ebp
80102f69:	c3                   	ret    
80102f6a:	83 c4 10             	add    $0x10,%esp
80102f6d:	89 f0                	mov    %esi,%eax
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5d                   	pop    %ebp
80102f72:	c3                   	ret    
80102f73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f80 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
80102f85:	53                   	push   %ebx
80102f86:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f89:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102f90:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102f97:	c1 e0 08             	shl    $0x8,%eax
80102f9a:	09 d0                	or     %edx,%eax
80102f9c:	c1 e0 04             	shl    $0x4,%eax
80102f9f:	85 c0                	test   %eax,%eax
80102fa1:	75 1b                	jne    80102fbe <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fa3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102faa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fb1:	c1 e0 08             	shl    $0x8,%eax
80102fb4:	09 d0                	or     %edx,%eax
80102fb6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fb9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102fbe:	ba 00 04 00 00       	mov    $0x400,%edx
80102fc3:	e8 48 ff ff ff       	call   80102f10 <mpsearch1>
80102fc8:	85 c0                	test   %eax,%eax
80102fca:	89 c7                	mov    %eax,%edi
80102fcc:	0f 84 22 01 00 00    	je     801030f4 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fd2:	8b 77 04             	mov    0x4(%edi),%esi
80102fd5:	85 f6                	test   %esi,%esi
80102fd7:	0f 84 30 01 00 00    	je     8010310d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fdd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80102fe3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fea:	00 
80102feb:	c7 44 24 04 1d 73 10 	movl   $0x8010731d,0x4(%esp)
80102ff2:	80 
80102ff3:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ff6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102ff9:	e8 02 13 00 00       	call   80104300 <memcmp>
80102ffe:	85 c0                	test   %eax,%eax
80103000:	0f 85 07 01 00 00    	jne    8010310d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103006:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010300d:	3c 04                	cmp    $0x4,%al
8010300f:	0f 85 0b 01 00 00    	jne    80103120 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103015:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010301c:	85 c0                	test   %eax,%eax
8010301e:	74 21                	je     80103041 <mpinit+0xc1>
  sum = 0;
80103020:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103022:	31 d2                	xor    %edx,%edx
80103024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103028:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010302f:	80 
  for(i=0; i<len; i++)
80103030:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103033:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103035:	39 d0                	cmp    %edx,%eax
80103037:	7f ef                	jg     80103028 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103039:	84 c9                	test   %cl,%cl
8010303b:	0f 85 cc 00 00 00    	jne    8010310d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103044:	85 c0                	test   %eax,%eax
80103046:	0f 84 c1 00 00 00    	je     8010310d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010304c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103052:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103057:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010305c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103063:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103069:	03 55 e4             	add    -0x1c(%ebp),%edx
8010306c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103070:	39 c2                	cmp    %eax,%edx
80103072:	76 1b                	jbe    8010308f <mpinit+0x10f>
80103074:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103077:	80 f9 04             	cmp    $0x4,%cl
8010307a:	77 74                	ja     801030f0 <mpinit+0x170>
8010307c:	ff 24 8d 5c 73 10 80 	jmp    *-0x7fef8ca4(,%ecx,4)
80103083:	90                   	nop
80103084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103088:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010308b:	39 c2                	cmp    %eax,%edx
8010308d:	77 e5                	ja     80103074 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010308f:	85 db                	test   %ebx,%ebx
80103091:	0f 84 93 00 00 00    	je     8010312a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103097:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010309b:	74 12                	je     801030af <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010309d:	ba 22 00 00 00       	mov    $0x22,%edx
801030a2:	b8 70 00 00 00       	mov    $0x70,%eax
801030a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a8:	b2 23                	mov    $0x23,%dl
801030aa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030ab:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ae:	ee                   	out    %al,(%dx)
  }
}
801030af:	83 c4 1c             	add    $0x1c,%esp
801030b2:	5b                   	pop    %ebx
801030b3:	5e                   	pop    %esi
801030b4:	5f                   	pop    %edi
801030b5:	5d                   	pop    %ebp
801030b6:	c3                   	ret    
801030b7:	90                   	nop
      if(ncpu < NCPU) {
801030b8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030be:	83 fe 07             	cmp    $0x7,%esi
801030c1:	7f 17                	jg     801030da <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030c3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030c7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030cd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030d4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
801030da:	83 c0 14             	add    $0x14,%eax
      continue;
801030dd:	eb 91                	jmp    80103070 <mpinit+0xf0>
801030df:	90                   	nop
      ioapicid = ioapic->apicno;
801030e0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801030e4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801030e7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
801030ed:	eb 81                	jmp    80103070 <mpinit+0xf0>
801030ef:	90                   	nop
      ismp = 0;
801030f0:	31 db                	xor    %ebx,%ebx
801030f2:	eb 83                	jmp    80103077 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
801030f4:	ba 00 00 01 00       	mov    $0x10000,%edx
801030f9:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801030fe:	e8 0d fe ff ff       	call   80102f10 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103103:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103105:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103107:	0f 85 c5 fe ff ff    	jne    80102fd2 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010310d:	c7 04 24 22 73 10 80 	movl   $0x80107322,(%esp)
80103114:	e8 47 d2 ff ff       	call   80100360 <panic>
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103120:	3c 01                	cmp    $0x1,%al
80103122:	0f 84 ed fe ff ff    	je     80103015 <mpinit+0x95>
80103128:	eb e3                	jmp    8010310d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010312a:	c7 04 24 3c 73 10 80 	movl   $0x8010733c,(%esp)
80103131:	e8 2a d2 ff ff       	call   80100360 <panic>
80103136:	66 90                	xchg   %ax,%ax
80103138:	66 90                	xchg   %ax,%ax
8010313a:	66 90                	xchg   %ax,%ax
8010313c:	66 90                	xchg   %ax,%ax
8010313e:	66 90                	xchg   %ax,%ax

80103140 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103140:	55                   	push   %ebp
80103141:	ba 21 00 00 00       	mov    $0x21,%edx
80103146:	89 e5                	mov    %esp,%ebp
80103148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010314d:	ee                   	out    %al,(%dx)
8010314e:	b2 a1                	mov    $0xa1,%dl
80103150:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103151:	5d                   	pop    %ebp
80103152:	c3                   	ret    
80103153:	66 90                	xchg   %ax,%ax
80103155:	66 90                	xchg   %ax,%ax
80103157:	66 90                	xchg   %ax,%ax
80103159:	66 90                	xchg   %ax,%ax
8010315b:	66 90                	xchg   %ax,%ax
8010315d:	66 90                	xchg   %ax,%ax
8010315f:	90                   	nop

80103160 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
80103165:	53                   	push   %ebx
80103166:	83 ec 1c             	sub    $0x1c,%esp
80103169:	8b 75 08             	mov    0x8(%ebp),%esi
8010316c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010316f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103175:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010317b:	e8 d0 db ff ff       	call   80100d50 <filealloc>
80103180:	85 c0                	test   %eax,%eax
80103182:	89 06                	mov    %eax,(%esi)
80103184:	0f 84 a4 00 00 00    	je     8010322e <pipealloc+0xce>
8010318a:	e8 c1 db ff ff       	call   80100d50 <filealloc>
8010318f:	85 c0                	test   %eax,%eax
80103191:	89 03                	mov    %eax,(%ebx)
80103193:	0f 84 87 00 00 00    	je     80103220 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103199:	e8 f2 f2 ff ff       	call   80102490 <kalloc>
8010319e:	85 c0                	test   %eax,%eax
801031a0:	89 c7                	mov    %eax,%edi
801031a2:	74 7c                	je     80103220 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031a4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031ab:	00 00 00 
  p->writeopen = 1;
801031ae:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031b5:	00 00 00 
  p->nwrite = 0;
801031b8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031bf:	00 00 00 
  p->nread = 0;
801031c2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031c9:	00 00 00 
  initlock(&p->lock, "pipe");
801031cc:	89 04 24             	mov    %eax,(%esp)
801031cf:	c7 44 24 04 70 73 10 	movl   $0x80107370,0x4(%esp)
801031d6:	80 
801031d7:	e8 a4 0e 00 00       	call   80104080 <initlock>
  (*f0)->type = FD_PIPE;
801031dc:	8b 06                	mov    (%esi),%eax
801031de:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801031e4:	8b 06                	mov    (%esi),%eax
801031e6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801031ea:	8b 06                	mov    (%esi),%eax
801031ec:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801031f0:	8b 06                	mov    (%esi),%eax
801031f2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801031f5:	8b 03                	mov    (%ebx),%eax
801031f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801031fd:	8b 03                	mov    (%ebx),%eax
801031ff:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103203:	8b 03                	mov    (%ebx),%eax
80103205:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103209:	8b 03                	mov    (%ebx),%eax
  return 0;
8010320b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010320d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103210:	83 c4 1c             	add    $0x1c,%esp
80103213:	89 d8                	mov    %ebx,%eax
80103215:	5b                   	pop    %ebx
80103216:	5e                   	pop    %esi
80103217:	5f                   	pop    %edi
80103218:	5d                   	pop    %ebp
80103219:	c3                   	ret    
8010321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103220:	8b 06                	mov    (%esi),%eax
80103222:	85 c0                	test   %eax,%eax
80103224:	74 08                	je     8010322e <pipealloc+0xce>
    fileclose(*f0);
80103226:	89 04 24             	mov    %eax,(%esp)
80103229:	e8 e2 db ff ff       	call   80100e10 <fileclose>
  if(*f1)
8010322e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103230:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103235:	85 c0                	test   %eax,%eax
80103237:	74 d7                	je     80103210 <pipealloc+0xb0>
    fileclose(*f1);
80103239:	89 04 24             	mov    %eax,(%esp)
8010323c:	e8 cf db ff ff       	call   80100e10 <fileclose>
}
80103241:	83 c4 1c             	add    $0x1c,%esp
80103244:	89 d8                	mov    %ebx,%eax
80103246:	5b                   	pop    %ebx
80103247:	5e                   	pop    %esi
80103248:	5f                   	pop    %edi
80103249:	5d                   	pop    %ebp
8010324a:	c3                   	ret    
8010324b:	90                   	nop
8010324c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103250 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	56                   	push   %esi
80103254:	53                   	push   %ebx
80103255:	83 ec 10             	sub    $0x10,%esp
80103258:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010325e:	89 1c 24             	mov    %ebx,(%esp)
80103261:	e8 0a 0f 00 00       	call   80104170 <acquire>
  if(writable){
80103266:	85 f6                	test   %esi,%esi
80103268:	74 3e                	je     801032a8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010326a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103270:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103277:	00 00 00 
    wakeup(&p->nread);
8010327a:	89 04 24             	mov    %eax,(%esp)
8010327d:	e8 2e 0b 00 00       	call   80103db0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103282:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103288:	85 d2                	test   %edx,%edx
8010328a:	75 0a                	jne    80103296 <pipeclose+0x46>
8010328c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	74 32                	je     801032c8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103296:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	5b                   	pop    %ebx
8010329d:	5e                   	pop    %esi
8010329e:	5d                   	pop    %ebp
    release(&p->lock);
8010329f:	e9 bc 0f 00 00       	jmp    80104260 <release>
801032a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032a8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032ae:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032b5:	00 00 00 
    wakeup(&p->nwrite);
801032b8:	89 04 24             	mov    %eax,(%esp)
801032bb:	e8 f0 0a 00 00       	call   80103db0 <wakeup>
801032c0:	eb c0                	jmp    80103282 <pipeclose+0x32>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032c8:	89 1c 24             	mov    %ebx,(%esp)
801032cb:	e8 90 0f 00 00       	call   80104260 <release>
    kfree((char*)p);
801032d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032d3:	83 c4 10             	add    $0x10,%esp
801032d6:	5b                   	pop    %ebx
801032d7:	5e                   	pop    %esi
801032d8:	5d                   	pop    %ebp
    kfree((char*)p);
801032d9:	e9 02 f0 ff ff       	jmp    801022e0 <kfree>
801032de:	66 90                	xchg   %ax,%ax

801032e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	57                   	push   %edi
801032e4:	56                   	push   %esi
801032e5:	53                   	push   %ebx
801032e6:	83 ec 1c             	sub    $0x1c,%esp
801032e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032ec:	89 1c 24             	mov    %ebx,(%esp)
801032ef:	e8 7c 0e 00 00       	call   80104170 <acquire>
  for(i = 0; i < n; i++){
801032f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801032f7:	85 c9                	test   %ecx,%ecx
801032f9:	0f 8e b2 00 00 00    	jle    801033b1 <pipewrite+0xd1>
801032ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103302:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103308:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010330e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103314:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103317:	03 4d 10             	add    0x10(%ebp),%ecx
8010331a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010331d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103323:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103329:	39 c8                	cmp    %ecx,%eax
8010332b:	74 38                	je     80103365 <pipewrite+0x85>
8010332d:	eb 55                	jmp    80103384 <pipewrite+0xa4>
8010332f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103330:	e8 5b 03 00 00       	call   80103690 <myproc>
80103335:	8b 40 2c             	mov    0x2c(%eax),%eax
80103338:	85 c0                	test   %eax,%eax
8010333a:	75 33                	jne    8010336f <pipewrite+0x8f>
      wakeup(&p->nread);
8010333c:	89 3c 24             	mov    %edi,(%esp)
8010333f:	e8 6c 0a 00 00       	call   80103db0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103344:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103348:	89 34 24             	mov    %esi,(%esp)
8010334b:	e8 c0 08 00 00       	call   80103c10 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103350:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103356:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010335c:	05 00 02 00 00       	add    $0x200,%eax
80103361:	39 c2                	cmp    %eax,%edx
80103363:	75 23                	jne    80103388 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103365:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010336b:	85 d2                	test   %edx,%edx
8010336d:	75 c1                	jne    80103330 <pipewrite+0x50>
        release(&p->lock);
8010336f:	89 1c 24             	mov    %ebx,(%esp)
80103372:	e8 e9 0e 00 00       	call   80104260 <release>
        return -1;
80103377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010337c:	83 c4 1c             	add    $0x1c,%esp
8010337f:	5b                   	pop    %ebx
80103380:	5e                   	pop    %esi
80103381:	5f                   	pop    %edi
80103382:	5d                   	pop    %ebp
80103383:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103384:	89 c2                	mov    %eax,%edx
80103386:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103388:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010338b:	8d 42 01             	lea    0x1(%edx),%eax
8010338e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103394:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010339a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010339e:	0f b6 09             	movzbl (%ecx),%ecx
801033a1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033a8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033ab:	0f 85 6c ff ff ff    	jne    8010331d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033b1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b7:	89 04 24             	mov    %eax,(%esp)
801033ba:	e8 f1 09 00 00       	call   80103db0 <wakeup>
  release(&p->lock);
801033bf:	89 1c 24             	mov    %ebx,(%esp)
801033c2:	e8 99 0e 00 00       	call   80104260 <release>
  return n;
801033c7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ca:	eb b0                	jmp    8010337c <pipewrite+0x9c>
801033cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	57                   	push   %edi
801033d4:	56                   	push   %esi
801033d5:	53                   	push   %ebx
801033d6:	83 ec 1c             	sub    $0x1c,%esp
801033d9:	8b 75 08             	mov    0x8(%ebp),%esi
801033dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033df:	89 34 24             	mov    %esi,(%esp)
801033e2:	e8 89 0d 00 00       	call   80104170 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033e7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033ed:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033f3:	75 5b                	jne    80103450 <piperead+0x80>
801033f5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801033fb:	85 db                	test   %ebx,%ebx
801033fd:	74 51                	je     80103450 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033ff:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103405:	eb 25                	jmp    8010342c <piperead+0x5c>
80103407:	90                   	nop
80103408:	89 74 24 04          	mov    %esi,0x4(%esp)
8010340c:	89 1c 24             	mov    %ebx,(%esp)
8010340f:	e8 fc 07 00 00       	call   80103c10 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103414:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010341a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103420:	75 2e                	jne    80103450 <piperead+0x80>
80103422:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103428:	85 d2                	test   %edx,%edx
8010342a:	74 24                	je     80103450 <piperead+0x80>
    if(myproc()->killed){
8010342c:	e8 5f 02 00 00       	call   80103690 <myproc>
80103431:	8b 48 2c             	mov    0x2c(%eax),%ecx
80103434:	85 c9                	test   %ecx,%ecx
80103436:	74 d0                	je     80103408 <piperead+0x38>
      release(&p->lock);
80103438:	89 34 24             	mov    %esi,(%esp)
8010343b:	e8 20 0e 00 00       	call   80104260 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103440:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103448:	5b                   	pop    %ebx
80103449:	5e                   	pop    %esi
8010344a:	5f                   	pop    %edi
8010344b:	5d                   	pop    %ebp
8010344c:	c3                   	ret    
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103450:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103453:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103455:	85 d2                	test   %edx,%edx
80103457:	7f 2b                	jg     80103484 <piperead+0xb4>
80103459:	eb 31                	jmp    8010348c <piperead+0xbc>
8010345b:	90                   	nop
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103460:	8d 48 01             	lea    0x1(%eax),%ecx
80103463:	25 ff 01 00 00       	and    $0x1ff,%eax
80103468:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010346e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103473:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103476:	83 c3 01             	add    $0x1,%ebx
80103479:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010347c:	74 0e                	je     8010348c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010347e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103484:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010348a:	75 d4                	jne    80103460 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010348c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103492:	89 04 24             	mov    %eax,(%esp)
80103495:	e8 16 09 00 00       	call   80103db0 <wakeup>
  release(&p->lock);
8010349a:	89 34 24             	mov    %esi,(%esp)
8010349d:	e8 be 0d 00 00       	call   80104260 <release>
}
801034a2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034a5:	89 d8                	mov    %ebx,%eax
}
801034a7:	5b                   	pop    %ebx
801034a8:	5e                   	pop    %esi
801034a9:	5f                   	pop    %edi
801034aa:	5d                   	pop    %ebp
801034ab:	c3                   	ret    
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034b9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034bc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034c3:	e8 a8 0c 00 00       	call   80104170 <acquire>
801034c8:	eb 14                	jmp    801034de <allocproc+0x2e>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801034d6:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801034dc:	74 7a                	je     80103558 <allocproc+0xa8>
    if(p->state == UNUSED)
801034de:	8b 43 14             	mov    0x14(%ebx),%eax
801034e1:	85 c0                	test   %eax,%eax
801034e3:	75 eb                	jne    801034d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034e5:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801034ea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
801034f1:	c7 43 14 01 00 00 00 	movl   $0x1,0x14(%ebx)
  p->pid = nextpid++;
801034f8:	8d 50 01             	lea    0x1(%eax),%edx
801034fb:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103501:	89 43 18             	mov    %eax,0x18(%ebx)
  release(&ptable.lock);
80103504:	e8 57 0d 00 00       	call   80104260 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103509:	e8 82 ef ff ff       	call   80102490 <kalloc>
8010350e:	85 c0                	test   %eax,%eax
80103510:	89 43 10             	mov    %eax,0x10(%ebx)
80103513:	74 57                	je     8010356c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103515:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010351b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103520:	89 53 20             	mov    %edx,0x20(%ebx)
  *(uint*)sp = (uint)trapret;
80103523:	c7 40 14 85 54 10 80 	movl   $0x80105485,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010352a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103531:	00 
80103532:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103539:	00 
8010353a:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010353d:	89 43 24             	mov    %eax,0x24(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103540:	e8 6b 0d 00 00       	call   801042b0 <memset>
  p->context->eip = (uint)forkret;
80103545:	8b 43 24             	mov    0x24(%ebx),%eax
80103548:	c7 40 10 80 35 10 80 	movl   $0x80103580,0x10(%eax)

  return p;
8010354f:	89 d8                	mov    %ebx,%eax
}
80103551:	83 c4 14             	add    $0x14,%esp
80103554:	5b                   	pop    %ebx
80103555:	5d                   	pop    %ebp
80103556:	c3                   	ret    
80103557:	90                   	nop
  release(&ptable.lock);
80103558:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010355f:	e8 fc 0c 00 00       	call   80104260 <release>
}
80103564:	83 c4 14             	add    $0x14,%esp
  return 0;
80103567:	31 c0                	xor    %eax,%eax
}
80103569:	5b                   	pop    %ebx
8010356a:	5d                   	pop    %ebp
8010356b:	c3                   	ret    
    p->state = UNUSED;
8010356c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    return 0;
80103573:	eb dc                	jmp    80103551 <allocproc+0xa1>
80103575:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103580 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103586:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010358d:	e8 ce 0c 00 00       	call   80104260 <release>

  if (first) {
80103592:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	75 05                	jne    801035a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010359b:	c9                   	leave  
8010359c:	c3                   	ret    
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035a7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035ae:	00 00 00 
    iinit(ROOTDEV);
801035b1:	e8 aa de ff ff       	call   80101460 <iinit>
    initlog(ROOTDEV);
801035b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035bd:	e8 9e f4 ff ff       	call   80102a60 <initlog>
}
801035c2:	c9                   	leave  
801035c3:	c3                   	ret    
801035c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035d0 <pinit>:
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801035d6:	c7 44 24 04 75 73 10 	movl   $0x80107375,0x4(%esp)
801035dd:	80 
801035de:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035e5:	e8 96 0a 00 00       	call   80104080 <initlock>
}
801035ea:	c9                   	leave  
801035eb:	c3                   	ret    
801035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801035f0 <mycpu>:
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035f8:	9c                   	pushf  
801035f9:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035fa:	f6 c4 02             	test   $0x2,%ah
801035fd:	75 57                	jne    80103656 <mycpu+0x66>
  apicid = lapicid();
801035ff:	e8 4c f1 ff ff       	call   80102750 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103604:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010360a:	85 f6                	test   %esi,%esi
8010360c:	7e 3c                	jle    8010364a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010360e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103615:	39 c2                	cmp    %eax,%edx
80103617:	74 2d                	je     80103646 <mycpu+0x56>
80103619:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010361e:	31 d2                	xor    %edx,%edx
80103620:	83 c2 01             	add    $0x1,%edx
80103623:	39 f2                	cmp    %esi,%edx
80103625:	74 23                	je     8010364a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103627:	0f b6 19             	movzbl (%ecx),%ebx
8010362a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103630:	39 c3                	cmp    %eax,%ebx
80103632:	75 ec                	jne    80103620 <mycpu+0x30>
      return &cpus[i];
80103634:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010363a:	83 c4 10             	add    $0x10,%esp
8010363d:	5b                   	pop    %ebx
8010363e:	5e                   	pop    %esi
8010363f:	5d                   	pop    %ebp
      return &cpus[i];
80103640:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103645:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103646:	31 d2                	xor    %edx,%edx
80103648:	eb ea                	jmp    80103634 <mycpu+0x44>
  panic("unknown apicid\n");
8010364a:	c7 04 24 7c 73 10 80 	movl   $0x8010737c,(%esp)
80103651:	e8 0a cd ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103656:	c7 04 24 58 74 10 80 	movl   $0x80107458,(%esp)
8010365d:	e8 fe cc ff ff       	call   80100360 <panic>
80103662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103670 <cpuid>:
cpuid() {
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103676:	e8 75 ff ff ff       	call   801035f0 <mycpu>
}
8010367b:	c9                   	leave  
  return mycpu()-cpus;
8010367c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103681:	c1 f8 04             	sar    $0x4,%eax
80103684:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010368a:	c3                   	ret    
8010368b:	90                   	nop
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103690 <myproc>:
myproc(void) {
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	53                   	push   %ebx
80103694:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103697:	e8 94 0a 00 00       	call   80104130 <pushcli>
  c = mycpu();
8010369c:	e8 4f ff ff ff       	call   801035f0 <mycpu>
  p = c->proc;
801036a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036a7:	e8 44 0b 00 00       	call   801041f0 <popcli>
}
801036ac:	83 c4 04             	add    $0x4,%esp
801036af:	89 d8                	mov    %ebx,%eax
801036b1:	5b                   	pop    %ebx
801036b2:	5d                   	pop    %ebp
801036b3:	c3                   	ret    
801036b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036c0 <userinit>:
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
801036c7:	e8 e4 fd ff ff       	call   801034b0 <allocproc>
801036cc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801036ce:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801036d3:	e8 38 33 00 00       	call   80106a10 <setupkvm>
801036d8:	85 c0                	test   %eax,%eax
801036da:	89 43 0c             	mov    %eax,0xc(%ebx)
801036dd:	0f 84 d4 00 00 00    	je     801037b7 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801036e3:	89 04 24             	mov    %eax,(%esp)
801036e6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801036ed:	00 
801036ee:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801036f5:	80 
801036f6:	e8 25 30 00 00       	call   80106720 <inituvm>
  p->sz = PGSIZE;
801036fb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103701:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103708:	00 
80103709:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103710:	00 
80103711:	8b 43 20             	mov    0x20(%ebx),%eax
80103714:	89 04 24             	mov    %eax,(%esp)
80103717:	e8 94 0b 00 00       	call   801042b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010371c:	8b 43 20             	mov    0x20(%ebx),%eax
8010371f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103724:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103729:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010372d:	8b 43 20             	mov    0x20(%ebx),%eax
80103730:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103734:	8b 43 20             	mov    0x20(%ebx),%eax
80103737:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010373b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010373f:	8b 43 20             	mov    0x20(%ebx),%eax
80103742:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103746:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010374a:	8b 43 20             	mov    0x20(%ebx),%eax
8010374d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103754:	8b 43 20             	mov    0x20(%ebx),%eax
80103757:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010375e:	8b 43 20             	mov    0x20(%ebx),%eax
80103761:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103768:	8d 43 74             	lea    0x74(%ebx),%eax
8010376b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103772:	00 
80103773:	c7 44 24 04 a5 73 10 	movl   $0x801073a5,0x4(%esp)
8010377a:	80 
8010377b:	89 04 24             	mov    %eax,(%esp)
8010377e:	e8 0d 0d 00 00       	call   80104490 <safestrcpy>
  p->cwd = namei("/");
80103783:	c7 04 24 ae 73 10 80 	movl   $0x801073ae,(%esp)
8010378a:	e8 61 e7 ff ff       	call   80101ef0 <namei>
8010378f:	89 43 70             	mov    %eax,0x70(%ebx)
  acquire(&ptable.lock);
80103792:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103799:	e8 d2 09 00 00       	call   80104170 <acquire>
  p->state = RUNNABLE;
8010379e:	c7 43 14 03 00 00 00 	movl   $0x3,0x14(%ebx)
  release(&ptable.lock);
801037a5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037ac:	e8 af 0a 00 00       	call   80104260 <release>
}
801037b1:	83 c4 14             	add    $0x14,%esp
801037b4:	5b                   	pop    %ebx
801037b5:	5d                   	pop    %ebp
801037b6:	c3                   	ret    
    panic("userinit: out of memory?");
801037b7:	c7 04 24 8c 73 10 80 	movl   $0x8010738c,(%esp)
801037be:	e8 9d cb ff ff       	call   80100360 <panic>
801037c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037d0 <growproc>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	56                   	push   %esi
801037d4:	53                   	push   %ebx
801037d5:	83 ec 10             	sub    $0x10,%esp
801037d8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801037db:	e8 b0 fe ff ff       	call   80103690 <myproc>
  if(n > 0){
801037e0:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
801037e3:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801037e5:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801037e7:	7e 2f                	jle    80103818 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037e9:	01 c6                	add    %eax,%esi
801037eb:	89 74 24 08          	mov    %esi,0x8(%esp)
801037ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801037f3:	8b 43 0c             	mov    0xc(%ebx),%eax
801037f6:	89 04 24             	mov    %eax,(%esp)
801037f9:	e8 72 30 00 00       	call   80106870 <allocuvm>
801037fe:	85 c0                	test   %eax,%eax
80103800:	74 36                	je     80103838 <growproc+0x68>
  curproc->sz = sz;
80103802:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103804:	89 1c 24             	mov    %ebx,(%esp)
80103807:	e8 04 2e 00 00       	call   80106610 <switchuvm>
  return 0;
8010380c:	31 c0                	xor    %eax,%eax
}
8010380e:	83 c4 10             	add    $0x10,%esp
80103811:	5b                   	pop    %ebx
80103812:	5e                   	pop    %esi
80103813:	5d                   	pop    %ebp
80103814:	c3                   	ret    
80103815:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103818:	74 e8                	je     80103802 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010381a:	01 c6                	add    %eax,%esi
8010381c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103820:	89 44 24 04          	mov    %eax,0x4(%esp)
80103824:	8b 43 0c             	mov    0xc(%ebx),%eax
80103827:	89 04 24             	mov    %eax,(%esp)
8010382a:	e8 41 31 00 00       	call   80106970 <deallocuvm>
8010382f:	85 c0                	test   %eax,%eax
80103831:	75 cf                	jne    80103802 <growproc+0x32>
80103833:	90                   	nop
80103834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010383d:	eb cf                	jmp    8010380e <growproc+0x3e>
8010383f:	90                   	nop

80103840 <fork>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *curproc = myproc();
80103849:	e8 42 fe ff ff       	call   80103690 <myproc>
8010384e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103850:	e8 5b fc ff ff       	call   801034b0 <allocproc>
80103855:	85 c0                	test   %eax,%eax
80103857:	89 c7                	mov    %eax,%edi
80103859:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010385c:	0f 84 cc 00 00 00    	je     8010392e <fork+0xee>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->sm, curproc->spgcount)) == 0){
80103862:	8b 43 08             	mov    0x8(%ebx),%eax
80103865:	89 44 24 0c          	mov    %eax,0xc(%esp)
80103869:	8b 43 04             	mov    0x4(%ebx),%eax
8010386c:	89 44 24 08          	mov    %eax,0x8(%esp)
80103870:	8b 03                	mov    (%ebx),%eax
80103872:	89 44 24 04          	mov    %eax,0x4(%esp)
80103876:	8b 43 0c             	mov    0xc(%ebx),%eax
80103879:	89 04 24             	mov    %eax,(%esp)
8010387c:	e8 6f 32 00 00       	call   80106af0 <copyuvm>
80103881:	85 c0                	test   %eax,%eax
80103883:	89 47 0c             	mov    %eax,0xc(%edi)
80103886:	0f 84 a9 00 00 00    	je     80103935 <fork+0xf5>
  np->sz = curproc->sz;
8010388c:	8b 03                	mov    (%ebx),%eax
8010388e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103891:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103893:	8b 79 20             	mov    0x20(%ecx),%edi
80103896:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
80103898:	89 59 1c             	mov    %ebx,0x1c(%ecx)
  *np->tf = *curproc->tf;
8010389b:	8b 73 20             	mov    0x20(%ebx),%esi
8010389e:	b9 13 00 00 00       	mov    $0x13,%ecx
801038a3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038a5:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801038a7:	8b 40 20             	mov    0x20(%eax),%eax
801038aa:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801038b8:	8b 44 b3 30          	mov    0x30(%ebx,%esi,4),%eax
801038bc:	85 c0                	test   %eax,%eax
801038be:	74 0f                	je     801038cf <fork+0x8f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038c0:	89 04 24             	mov    %eax,(%esp)
801038c3:	e8 f8 d4 ff ff       	call   80100dc0 <filedup>
801038c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038cb:	89 44 b2 30          	mov    %eax,0x30(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801038cf:	83 c6 01             	add    $0x1,%esi
801038d2:	83 fe 10             	cmp    $0x10,%esi
801038d5:	75 e1                	jne    801038b8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
801038d7:	8b 43 70             	mov    0x70(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038da:	83 c3 74             	add    $0x74,%ebx
  np->cwd = idup(curproc->cwd);
801038dd:	89 04 24             	mov    %eax,(%esp)
801038e0:	e8 8b dd ff ff       	call   80101670 <idup>
801038e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038e8:	89 47 70             	mov    %eax,0x70(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038eb:	8d 47 74             	lea    0x74(%edi),%eax
801038ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801038f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801038f9:	00 
801038fa:	89 04 24             	mov    %eax,(%esp)
801038fd:	e8 8e 0b 00 00       	call   80104490 <safestrcpy>
  pid = np->pid;
80103902:	8b 5f 18             	mov    0x18(%edi),%ebx
  acquire(&ptable.lock);
80103905:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010390c:	e8 5f 08 00 00       	call   80104170 <acquire>
  np->state = RUNNABLE;
80103911:	c7 47 14 03 00 00 00 	movl   $0x3,0x14(%edi)
  release(&ptable.lock);
80103918:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010391f:	e8 3c 09 00 00       	call   80104260 <release>
  return pid;
80103924:	89 d8                	mov    %ebx,%eax
}
80103926:	83 c4 2c             	add    $0x2c,%esp
80103929:	5b                   	pop    %ebx
8010392a:	5e                   	pop    %esi
8010392b:	5f                   	pop    %edi
8010392c:	5d                   	pop    %ebp
8010392d:	c3                   	ret    
    return -1;
8010392e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103933:	eb f1                	jmp    80103926 <fork+0xe6>
    kfree(np->kstack);
80103935:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103938:	8b 47 10             	mov    0x10(%edi),%eax
8010393b:	89 04 24             	mov    %eax,(%esp)
8010393e:	e8 9d e9 ff ff       	call   801022e0 <kfree>
    return -1;
80103943:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103948:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
    np->state = UNUSED;
8010394f:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    return -1;
80103956:	eb ce                	jmp    80103926 <fork+0xe6>
80103958:	90                   	nop
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103960 <scheduler>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	57                   	push   %edi
80103964:	56                   	push   %esi
80103965:	53                   	push   %ebx
80103966:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103969:	e8 82 fc ff ff       	call   801035f0 <mycpu>
8010396e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103970:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103977:	00 00 00 
8010397a:	8d 78 04             	lea    0x4(%eax),%edi
8010397d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103980:	fb                   	sti    
    acquire(&ptable.lock);
80103981:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103988:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
8010398d:	e8 de 07 00 00       	call   80104170 <acquire>
80103992:	eb 12                	jmp    801039a6 <scheduler+0x46>
80103994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103998:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010399e:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801039a4:	74 4a                	je     801039f0 <scheduler+0x90>
      if(p->state != RUNNABLE)
801039a6:	83 7b 14 03          	cmpl   $0x3,0x14(%ebx)
801039aa:	75 ec                	jne    80103998 <scheduler+0x38>
      c->proc = p;
801039ac:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039b2:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b5:	81 c3 84 00 00 00    	add    $0x84,%ebx
      switchuvm(p);
801039bb:	e8 50 2c 00 00       	call   80106610 <switchuvm>
      swtch(&(c->scheduler), p->context);
801039c0:	8b 43 a0             	mov    -0x60(%ebx),%eax
      p->state = RUNNING;
801039c3:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&(c->scheduler), p->context);
801039ca:	89 3c 24             	mov    %edi,(%esp)
801039cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801039d1:	e8 15 0b 00 00       	call   801044eb <swtch>
      switchkvm();
801039d6:	e8 15 2c 00 00       	call   801065f0 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039db:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
      c->proc = 0;
801039e1:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039e8:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039eb:	75 b9                	jne    801039a6 <scheduler+0x46>
801039ed:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
801039f0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039f7:	e8 64 08 00 00       	call   80104260 <release>
  }
801039fc:	eb 82                	jmp    80103980 <scheduler+0x20>
801039fe:	66 90                	xchg   %ax,%ax

80103a00 <sched>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	56                   	push   %esi
80103a04:	53                   	push   %ebx
80103a05:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103a08:	e8 83 fc ff ff       	call   80103690 <myproc>
  if(!holding(&ptable.lock))
80103a0d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103a14:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a16:	e8 e5 06 00 00       	call   80104100 <holding>
80103a1b:	85 c0                	test   %eax,%eax
80103a1d:	74 4f                	je     80103a6e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a1f:	e8 cc fb ff ff       	call   801035f0 <mycpu>
80103a24:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a2b:	75 65                	jne    80103a92 <sched+0x92>
  if(p->state == RUNNING)
80103a2d:	83 7b 14 04          	cmpl   $0x4,0x14(%ebx)
80103a31:	74 53                	je     80103a86 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a33:	9c                   	pushf  
80103a34:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a35:	f6 c4 02             	test   $0x2,%ah
80103a38:	75 40                	jne    80103a7a <sched+0x7a>
  intena = mycpu()->intena;
80103a3a:	e8 b1 fb ff ff       	call   801035f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a3f:	83 c3 24             	add    $0x24,%ebx
  intena = mycpu()->intena;
80103a42:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a48:	e8 a3 fb ff ff       	call   801035f0 <mycpu>
80103a4d:	8b 40 04             	mov    0x4(%eax),%eax
80103a50:	89 1c 24             	mov    %ebx,(%esp)
80103a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a57:	e8 8f 0a 00 00       	call   801044eb <swtch>
  mycpu()->intena = intena;
80103a5c:	e8 8f fb ff ff       	call   801035f0 <mycpu>
80103a61:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a67:	83 c4 10             	add    $0x10,%esp
80103a6a:	5b                   	pop    %ebx
80103a6b:	5e                   	pop    %esi
80103a6c:	5d                   	pop    %ebp
80103a6d:	c3                   	ret    
    panic("sched ptable.lock");
80103a6e:	c7 04 24 b0 73 10 80 	movl   $0x801073b0,(%esp)
80103a75:	e8 e6 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103a7a:	c7 04 24 dc 73 10 80 	movl   $0x801073dc,(%esp)
80103a81:	e8 da c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103a86:	c7 04 24 ce 73 10 80 	movl   $0x801073ce,(%esp)
80103a8d:	e8 ce c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103a92:	c7 04 24 c2 73 10 80 	movl   $0x801073c2,(%esp)
80103a99:	e8 c2 c8 ff ff       	call   80100360 <panic>
80103a9e:	66 90                	xchg   %ax,%ax

80103aa0 <exit>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
  if(curproc == initproc)
80103aa4:	31 f6                	xor    %esi,%esi
{
80103aa6:	53                   	push   %ebx
80103aa7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103aaa:	e8 e1 fb ff ff       	call   80103690 <myproc>
  if(curproc == initproc)
80103aaf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103ab5:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103ab7:	0f 84 fd 00 00 00    	je     80103bba <exit+0x11a>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ac0:	8b 44 b3 30          	mov    0x30(%ebx,%esi,4),%eax
80103ac4:	85 c0                	test   %eax,%eax
80103ac6:	74 10                	je     80103ad8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103ac8:	89 04 24             	mov    %eax,(%esp)
80103acb:	e8 40 d3 ff ff       	call   80100e10 <fileclose>
      curproc->ofile[fd] = 0;
80103ad0:	c7 44 b3 30 00 00 00 	movl   $0x0,0x30(%ebx,%esi,4)
80103ad7:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103ad8:	83 c6 01             	add    $0x1,%esi
80103adb:	83 fe 10             	cmp    $0x10,%esi
80103ade:	75 e0                	jne    80103ac0 <exit+0x20>
  begin_op();
80103ae0:	e8 1b f0 ff ff       	call   80102b00 <begin_op>
  iput(curproc->cwd);
80103ae5:	8b 43 70             	mov    0x70(%ebx),%eax
80103ae8:	89 04 24             	mov    %eax,(%esp)
80103aeb:	e8 d0 dc ff ff       	call   801017c0 <iput>
  end_op();
80103af0:	e8 7b f0 ff ff       	call   80102b70 <end_op>
  curproc->cwd = 0;
80103af5:	c7 43 70 00 00 00 00 	movl   $0x0,0x70(%ebx)
  acquire(&ptable.lock);
80103afc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b03:	e8 68 06 00 00       	call   80104170 <acquire>
  wakeup1(curproc->parent);
80103b08:	8b 43 1c             	mov    0x1c(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b0b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b10:	eb 14                	jmp    80103b26 <exit+0x86>
80103b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b18:	81 c2 84 00 00 00    	add    $0x84,%edx
80103b1e:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103b24:	74 20                	je     80103b46 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103b26:	83 7a 14 02          	cmpl   $0x2,0x14(%edx)
80103b2a:	75 ec                	jne    80103b18 <exit+0x78>
80103b2c:	3b 42 28             	cmp    0x28(%edx),%eax
80103b2f:	75 e7                	jne    80103b18 <exit+0x78>
      p->state = RUNNABLE;
80103b31:	c7 42 14 03 00 00 00 	movl   $0x3,0x14(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b38:	81 c2 84 00 00 00    	add    $0x84,%edx
80103b3e:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103b44:	75 e0                	jne    80103b26 <exit+0x86>
      p->parent = initproc;
80103b46:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b4b:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b50:	eb 14                	jmp    80103b66 <exit+0xc6>
80103b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b58:	81 c1 84 00 00 00    	add    $0x84,%ecx
80103b5e:	81 f9 54 4e 11 80    	cmp    $0x80114e54,%ecx
80103b64:	74 3c                	je     80103ba2 <exit+0x102>
    if(p->parent == curproc){
80103b66:	39 59 1c             	cmp    %ebx,0x1c(%ecx)
80103b69:	75 ed                	jne    80103b58 <exit+0xb8>
      if(p->state == ZOMBIE)
80103b6b:	83 79 14 05          	cmpl   $0x5,0x14(%ecx)
      p->parent = initproc;
80103b6f:	89 41 1c             	mov    %eax,0x1c(%ecx)
      if(p->state == ZOMBIE)
80103b72:	75 e4                	jne    80103b58 <exit+0xb8>
80103b74:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b79:	eb 13                	jmp    80103b8e <exit+0xee>
80103b7b:	90                   	nop
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b80:	81 c2 84 00 00 00    	add    $0x84,%edx
80103b86:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103b8c:	74 ca                	je     80103b58 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103b8e:	83 7a 14 02          	cmpl   $0x2,0x14(%edx)
80103b92:	75 ec                	jne    80103b80 <exit+0xe0>
80103b94:	3b 42 28             	cmp    0x28(%edx),%eax
80103b97:	75 e7                	jne    80103b80 <exit+0xe0>
      p->state = RUNNABLE;
80103b99:	c7 42 14 03 00 00 00 	movl   $0x3,0x14(%edx)
80103ba0:	eb de                	jmp    80103b80 <exit+0xe0>
  curproc->state = ZOMBIE;
80103ba2:	c7 43 14 05 00 00 00 	movl   $0x5,0x14(%ebx)
  sched();
80103ba9:	e8 52 fe ff ff       	call   80103a00 <sched>
  panic("zombie exit");
80103bae:	c7 04 24 fd 73 10 80 	movl   $0x801073fd,(%esp)
80103bb5:	e8 a6 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103bba:	c7 04 24 f0 73 10 80 	movl   $0x801073f0,(%esp)
80103bc1:	e8 9a c7 ff ff       	call   80100360 <panic>
80103bc6:	8d 76 00             	lea    0x0(%esi),%esi
80103bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bd0 <yield>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103bd6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bdd:	e8 8e 05 00 00       	call   80104170 <acquire>
  myproc()->state = RUNNABLE;
80103be2:	e8 a9 fa ff ff       	call   80103690 <myproc>
80103be7:	c7 40 14 03 00 00 00 	movl   $0x3,0x14(%eax)
  sched();
80103bee:	e8 0d fe ff ff       	call   80103a00 <sched>
  release(&ptable.lock);
80103bf3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bfa:	e8 61 06 00 00       	call   80104260 <release>
}
80103bff:	c9                   	leave  
80103c00:	c3                   	ret    
80103c01:	eb 0d                	jmp    80103c10 <sleep>
80103c03:	90                   	nop
80103c04:	90                   	nop
80103c05:	90                   	nop
80103c06:	90                   	nop
80103c07:	90                   	nop
80103c08:	90                   	nop
80103c09:	90                   	nop
80103c0a:	90                   	nop
80103c0b:	90                   	nop
80103c0c:	90                   	nop
80103c0d:	90                   	nop
80103c0e:	90                   	nop
80103c0f:	90                   	nop

80103c10 <sleep>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	57                   	push   %edi
80103c14:	56                   	push   %esi
80103c15:	53                   	push   %ebx
80103c16:	83 ec 1c             	sub    $0x1c,%esp
80103c19:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c1f:	e8 6c fa ff ff       	call   80103690 <myproc>
  if(p == 0)
80103c24:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103c26:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103c28:	0f 84 7c 00 00 00    	je     80103caa <sleep+0x9a>
  if(lk == 0)
80103c2e:	85 f6                	test   %esi,%esi
80103c30:	74 6c                	je     80103c9e <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c32:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c38:	74 46                	je     80103c80 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c3a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c41:	e8 2a 05 00 00       	call   80104170 <acquire>
    release(lk);
80103c46:	89 34 24             	mov    %esi,(%esp)
80103c49:	e8 12 06 00 00       	call   80104260 <release>
  p->chan = chan;
80103c4e:	89 7b 28             	mov    %edi,0x28(%ebx)
  p->state = SLEEPING;
80103c51:	c7 43 14 02 00 00 00 	movl   $0x2,0x14(%ebx)
  sched();
80103c58:	e8 a3 fd ff ff       	call   80103a00 <sched>
  p->chan = 0;
80103c5d:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
    release(&ptable.lock);
80103c64:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c6b:	e8 f0 05 00 00       	call   80104260 <release>
    acquire(lk);
80103c70:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103c73:	83 c4 1c             	add    $0x1c,%esp
80103c76:	5b                   	pop    %ebx
80103c77:	5e                   	pop    %esi
80103c78:	5f                   	pop    %edi
80103c79:	5d                   	pop    %ebp
    acquire(lk);
80103c7a:	e9 f1 04 00 00       	jmp    80104170 <acquire>
80103c7f:	90                   	nop
  p->chan = chan;
80103c80:	89 78 28             	mov    %edi,0x28(%eax)
  p->state = SLEEPING;
80103c83:	c7 40 14 02 00 00 00 	movl   $0x2,0x14(%eax)
  sched();
80103c8a:	e8 71 fd ff ff       	call   80103a00 <sched>
  p->chan = 0;
80103c8f:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
}
80103c96:	83 c4 1c             	add    $0x1c,%esp
80103c99:	5b                   	pop    %ebx
80103c9a:	5e                   	pop    %esi
80103c9b:	5f                   	pop    %edi
80103c9c:	5d                   	pop    %ebp
80103c9d:	c3                   	ret    
    panic("sleep without lk");
80103c9e:	c7 04 24 0f 74 10 80 	movl   $0x8010740f,(%esp)
80103ca5:	e8 b6 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103caa:	c7 04 24 09 74 10 80 	movl   $0x80107409,(%esp)
80103cb1:	e8 aa c6 ff ff       	call   80100360 <panic>
80103cb6:	8d 76 00             	lea    0x0(%esi),%esi
80103cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cc0 <wait>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
80103cc5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103cc8:	e8 c3 f9 ff ff       	call   80103690 <myproc>
  acquire(&ptable.lock);
80103ccd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103cd4:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103cd6:	e8 95 04 00 00       	call   80104170 <acquire>
    havekids = 0;
80103cdb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cdd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ce2:	eb 12                	jmp    80103cf6 <wait+0x36>
80103ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ce8:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103cee:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103cf4:	74 22                	je     80103d18 <wait+0x58>
      if(p->parent != curproc)
80103cf6:	39 73 1c             	cmp    %esi,0x1c(%ebx)
80103cf9:	75 ed                	jne    80103ce8 <wait+0x28>
      if(p->state == ZOMBIE){
80103cfb:	83 7b 14 05          	cmpl   $0x5,0x14(%ebx)
80103cff:	74 34                	je     80103d35 <wait+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d01:	81 c3 84 00 00 00    	add    $0x84,%ebx
      havekids = 1;
80103d07:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d0c:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103d12:	75 e2                	jne    80103cf6 <wait+0x36>
80103d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed){
80103d18:	85 c0                	test   %eax,%eax
80103d1a:	74 6e                	je     80103d8a <wait+0xca>
80103d1c:	8b 46 2c             	mov    0x2c(%esi),%eax
80103d1f:	85 c0                	test   %eax,%eax
80103d21:	75 67                	jne    80103d8a <wait+0xca>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d23:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d2a:	80 
80103d2b:	89 34 24             	mov    %esi,(%esp)
80103d2e:	e8 dd fe ff ff       	call   80103c10 <sleep>
  }
80103d33:	eb a6                	jmp    80103cdb <wait+0x1b>
        kfree(p->kstack);
80103d35:	8b 43 10             	mov    0x10(%ebx),%eax
        pid = p->pid;
80103d38:	8b 73 18             	mov    0x18(%ebx),%esi
        kfree(p->kstack);
80103d3b:	89 04 24             	mov    %eax,(%esp)
80103d3e:	e8 9d e5 ff ff       	call   801022e0 <kfree>
        freevm(p->pgdir);
80103d43:	8b 43 0c             	mov    0xc(%ebx),%eax
        p->kstack = 0;
80103d46:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        freevm(p->pgdir);
80103d4d:	89 04 24             	mov    %eax,(%esp)
80103d50:	e8 3b 2c 00 00       	call   80106990 <freevm>
        release(&ptable.lock);
80103d55:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103d5c:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->parent = 0;
80103d63:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
        p->name[0] = 0;
80103d6a:	c6 43 74 00          	movb   $0x0,0x74(%ebx)
        p->killed = 0;
80103d6e:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
        p->state = UNUSED;
80103d75:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        release(&ptable.lock);
80103d7c:	e8 df 04 00 00       	call   80104260 <release>
}
80103d81:	83 c4 10             	add    $0x10,%esp
        return pid;
80103d84:	89 f0                	mov    %esi,%eax
}
80103d86:	5b                   	pop    %ebx
80103d87:	5e                   	pop    %esi
80103d88:	5d                   	pop    %ebp
80103d89:	c3                   	ret    
      release(&ptable.lock);
80103d8a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d91:	e8 ca 04 00 00       	call   80104260 <release>
}
80103d96:	83 c4 10             	add    $0x10,%esp
      return -1;
80103d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d9e:	5b                   	pop    %ebx
80103d9f:	5e                   	pop    %esi
80103da0:	5d                   	pop    %ebp
80103da1:	c3                   	ret    
80103da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103db0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	53                   	push   %ebx
80103db4:	83 ec 14             	sub    $0x14,%esp
80103db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dc1:	e8 aa 03 00 00       	call   80104170 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dcb:	eb 0f                	jmp    80103ddc <wakeup+0x2c>
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi
80103dd0:	05 84 00 00 00       	add    $0x84,%eax
80103dd5:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103dda:	74 24                	je     80103e00 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103ddc:	83 78 14 02          	cmpl   $0x2,0x14(%eax)
80103de0:	75 ee                	jne    80103dd0 <wakeup+0x20>
80103de2:	3b 58 28             	cmp    0x28(%eax),%ebx
80103de5:	75 e9                	jne    80103dd0 <wakeup+0x20>
      p->state = RUNNABLE;
80103de7:	c7 40 14 03 00 00 00 	movl   $0x3,0x14(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dee:	05 84 00 00 00       	add    $0x84,%eax
80103df3:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103df8:	75 e2                	jne    80103ddc <wakeup+0x2c>
80103dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  wakeup1(chan);
  release(&ptable.lock);
80103e00:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103e07:	83 c4 14             	add    $0x14,%esp
80103e0a:	5b                   	pop    %ebx
80103e0b:	5d                   	pop    %ebp
  release(&ptable.lock);
80103e0c:	e9 4f 04 00 00       	jmp    80104260 <release>
80103e11:	eb 0d                	jmp    80103e20 <kill>
80103e13:	90                   	nop
80103e14:	90                   	nop
80103e15:	90                   	nop
80103e16:	90                   	nop
80103e17:	90                   	nop
80103e18:	90                   	nop
80103e19:	90                   	nop
80103e1a:	90                   	nop
80103e1b:	90                   	nop
80103e1c:	90                   	nop
80103e1d:	90                   	nop
80103e1e:	90                   	nop
80103e1f:	90                   	nop

80103e20 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	53                   	push   %ebx
80103e24:	83 ec 14             	sub    $0x14,%esp
80103e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e2a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e31:	e8 3a 03 00 00       	call   80104170 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e36:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e3b:	eb 0f                	jmp    80103e4c <kill+0x2c>
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi
80103e40:	05 84 00 00 00       	add    $0x84,%eax
80103e45:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103e4a:	74 3c                	je     80103e88 <kill+0x68>
    if(p->pid == pid){
80103e4c:	39 58 18             	cmp    %ebx,0x18(%eax)
80103e4f:	75 ef                	jne    80103e40 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e51:	83 78 14 02          	cmpl   $0x2,0x14(%eax)
      p->killed = 1;
80103e55:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
      if(p->state == SLEEPING)
80103e5c:	74 1a                	je     80103e78 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e5e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e65:	e8 f6 03 00 00       	call   80104260 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e6a:	83 c4 14             	add    $0x14,%esp
      return 0;
80103e6d:	31 c0                	xor    %eax,%eax
}
80103e6f:	5b                   	pop    %ebx
80103e70:	5d                   	pop    %ebp
80103e71:	c3                   	ret    
80103e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->state = RUNNABLE;
80103e78:	c7 40 14 03 00 00 00 	movl   $0x3,0x14(%eax)
80103e7f:	eb dd                	jmp    80103e5e <kill+0x3e>
80103e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103e88:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e8f:	e8 cc 03 00 00       	call   80104260 <release>
}
80103e94:	83 c4 14             	add    $0x14,%esp
  return -1;
80103e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e9c:	5b                   	pop    %ebx
80103e9d:	5d                   	pop    %ebp
80103e9e:	c3                   	ret    
80103e9f:	90                   	nop

80103ea0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	57                   	push   %edi
80103ea4:	56                   	push   %esi
80103ea5:	53                   	push   %ebx
80103ea6:	bb c8 2d 11 80       	mov    $0x80112dc8,%ebx
80103eab:	83 ec 4c             	sub    $0x4c,%esp
80103eae:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103eb1:	eb 23                	jmp    80103ed6 <procdump+0x36>
80103eb3:	90                   	nop
80103eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103eb8:	c7 04 24 9f 77 10 80 	movl   $0x8010779f,(%esp)
80103ebf:	e8 8c c7 ff ff       	call   80100650 <cprintf>
80103ec4:	81 c3 84 00 00 00    	add    $0x84,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eca:	81 fb c8 4e 11 80    	cmp    $0x80114ec8,%ebx
80103ed0:	0f 84 8a 00 00 00    	je     80103f60 <procdump+0xc0>
    if(p->state == UNUSED)
80103ed6:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103ed9:	85 c0                	test   %eax,%eax
80103edb:	74 e7                	je     80103ec4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103edd:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103ee0:	ba 20 74 10 80       	mov    $0x80107420,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ee5:	77 11                	ja     80103ef8 <procdump+0x58>
80103ee7:	8b 14 85 80 74 10 80 	mov    -0x7fef8b80(,%eax,4),%edx
      state = "???";
80103eee:	b8 20 74 10 80       	mov    $0x80107420,%eax
80103ef3:	85 d2                	test   %edx,%edx
80103ef5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103ef8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103efb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103eff:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f03:	c7 04 24 24 74 10 80 	movl   $0x80107424,(%esp)
80103f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f0e:	e8 3d c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f13:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f17:	75 9f                	jne    80103eb8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f19:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f20:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f23:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f26:	8b 40 0c             	mov    0xc(%eax),%eax
80103f29:	83 c0 08             	add    $0x8,%eax
80103f2c:	89 04 24             	mov    %eax,(%esp)
80103f2f:	e8 6c 01 00 00       	call   801040a0 <getcallerpcs>
80103f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f38:	8b 17                	mov    (%edi),%edx
80103f3a:	85 d2                	test   %edx,%edx
80103f3c:	0f 84 76 ff ff ff    	je     80103eb8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f42:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f46:	83 c7 04             	add    $0x4,%edi
80103f49:	c7 04 24 61 6e 10 80 	movl   $0x80106e61,(%esp)
80103f50:	e8 fb c6 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f55:	39 f7                	cmp    %esi,%edi
80103f57:	75 df                	jne    80103f38 <procdump+0x98>
80103f59:	e9 5a ff ff ff       	jmp    80103eb8 <procdump+0x18>
80103f5e:	66 90                	xchg   %ax,%ax
  }
}
80103f60:	83 c4 4c             	add    $0x4c,%esp
80103f63:	5b                   	pop    %ebx
80103f64:	5e                   	pop    %esi
80103f65:	5f                   	pop    %edi
80103f66:	5d                   	pop    %ebp
80103f67:	c3                   	ret    
80103f68:	66 90                	xchg   %ax,%ax
80103f6a:	66 90                	xchg   %ax,%ax
80103f6c:	66 90                	xchg   %ax,%ax
80103f6e:	66 90                	xchg   %ax,%ax

80103f70 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	53                   	push   %ebx
80103f74:	83 ec 14             	sub    $0x14,%esp
80103f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f7a:	c7 44 24 04 98 74 10 	movl   $0x80107498,0x4(%esp)
80103f81:	80 
80103f82:	8d 43 04             	lea    0x4(%ebx),%eax
80103f85:	89 04 24             	mov    %eax,(%esp)
80103f88:	e8 f3 00 00 00       	call   80104080 <initlock>
  lk->name = name;
80103f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f90:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f96:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103f9d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103fa0:	83 c4 14             	add    $0x14,%esp
80103fa3:	5b                   	pop    %ebx
80103fa4:	5d                   	pop    %ebp
80103fa5:	c3                   	ret    
80103fa6:	8d 76 00             	lea    0x0(%esi),%esi
80103fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fb0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	56                   	push   %esi
80103fb4:	53                   	push   %ebx
80103fb5:	83 ec 10             	sub    $0x10,%esp
80103fb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fbb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fbe:	89 34 24             	mov    %esi,(%esp)
80103fc1:	e8 aa 01 00 00       	call   80104170 <acquire>
  while (lk->locked) {
80103fc6:	8b 13                	mov    (%ebx),%edx
80103fc8:	85 d2                	test   %edx,%edx
80103fca:	74 16                	je     80103fe2 <acquiresleep+0x32>
80103fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103fd0:	89 74 24 04          	mov    %esi,0x4(%esp)
80103fd4:	89 1c 24             	mov    %ebx,(%esp)
80103fd7:	e8 34 fc ff ff       	call   80103c10 <sleep>
  while (lk->locked) {
80103fdc:	8b 03                	mov    (%ebx),%eax
80103fde:	85 c0                	test   %eax,%eax
80103fe0:	75 ee                	jne    80103fd0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103fe2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103fe8:	e8 a3 f6 ff ff       	call   80103690 <myproc>
80103fed:	8b 40 18             	mov    0x18(%eax),%eax
80103ff0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103ff3:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103ff6:	83 c4 10             	add    $0x10,%esp
80103ff9:	5b                   	pop    %ebx
80103ffa:	5e                   	pop    %esi
80103ffb:	5d                   	pop    %ebp
  release(&lk->lk);
80103ffc:	e9 5f 02 00 00       	jmp    80104260 <release>
80104001:	eb 0d                	jmp    80104010 <releasesleep>
80104003:	90                   	nop
80104004:	90                   	nop
80104005:	90                   	nop
80104006:	90                   	nop
80104007:	90                   	nop
80104008:	90                   	nop
80104009:	90                   	nop
8010400a:	90                   	nop
8010400b:	90                   	nop
8010400c:	90                   	nop
8010400d:	90                   	nop
8010400e:	90                   	nop
8010400f:	90                   	nop

80104010 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
80104015:	83 ec 10             	sub    $0x10,%esp
80104018:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010401b:	8d 73 04             	lea    0x4(%ebx),%esi
8010401e:	89 34 24             	mov    %esi,(%esp)
80104021:	e8 4a 01 00 00       	call   80104170 <acquire>
  lk->locked = 0;
80104026:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010402c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104033:	89 1c 24             	mov    %ebx,(%esp)
80104036:	e8 75 fd ff ff       	call   80103db0 <wakeup>
  release(&lk->lk);
8010403b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010403e:	83 c4 10             	add    $0x10,%esp
80104041:	5b                   	pop    %ebx
80104042:	5e                   	pop    %esi
80104043:	5d                   	pop    %ebp
  release(&lk->lk);
80104044:	e9 17 02 00 00       	jmp    80104260 <release>
80104049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104050 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	56                   	push   %esi
80104054:	53                   	push   %ebx
80104055:	83 ec 10             	sub    $0x10,%esp
80104058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010405b:	8d 73 04             	lea    0x4(%ebx),%esi
8010405e:	89 34 24             	mov    %esi,(%esp)
80104061:	e8 0a 01 00 00       	call   80104170 <acquire>
  r = lk->locked;
80104066:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104068:	89 34 24             	mov    %esi,(%esp)
8010406b:	e8 f0 01 00 00       	call   80104260 <release>
  return r;
}
80104070:	83 c4 10             	add    $0x10,%esp
80104073:	89 d8                	mov    %ebx,%eax
80104075:	5b                   	pop    %ebx
80104076:	5e                   	pop    %esi
80104077:	5d                   	pop    %ebp
80104078:	c3                   	ret    
80104079:	66 90                	xchg   %ax,%ax
8010407b:	66 90                	xchg   %ax,%ax
8010407d:	66 90                	xchg   %ax,%ax
8010407f:	90                   	nop

80104080 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104086:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104089:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010408f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104092:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104099:	5d                   	pop    %ebp
8010409a:	c3                   	ret    
8010409b:	90                   	nop
8010409c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040a3:	8b 45 08             	mov    0x8(%ebp),%eax
{
801040a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801040a9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801040aa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801040ad:	31 c0                	xor    %eax,%eax
801040af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040b0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801040b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040bc:	77 1a                	ja     801040d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040be:	8b 5a 04             	mov    0x4(%edx),%ebx
801040c1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801040c4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801040c7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801040c9:	83 f8 0a             	cmp    $0xa,%eax
801040cc:	75 e2                	jne    801040b0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040ce:	5b                   	pop    %ebx
801040cf:	5d                   	pop    %ebp
801040d0:	c3                   	ret    
801040d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801040d8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040df:	83 c0 01             	add    $0x1,%eax
801040e2:	83 f8 0a             	cmp    $0xa,%eax
801040e5:	74 e7                	je     801040ce <getcallerpcs+0x2e>
    pcs[i] = 0;
801040e7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040ee:	83 c0 01             	add    $0x1,%eax
801040f1:	83 f8 0a             	cmp    $0xa,%eax
801040f4:	75 e2                	jne    801040d8 <getcallerpcs+0x38>
801040f6:	eb d6                	jmp    801040ce <getcallerpcs+0x2e>
801040f8:	90                   	nop
801040f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104100 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104100:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
80104101:	31 c0                	xor    %eax,%eax
{
80104103:	89 e5                	mov    %esp,%ebp
80104105:	53                   	push   %ebx
80104106:	83 ec 04             	sub    $0x4,%esp
80104109:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010410c:	8b 0a                	mov    (%edx),%ecx
8010410e:	85 c9                	test   %ecx,%ecx
80104110:	74 10                	je     80104122 <holding+0x22>
80104112:	8b 5a 08             	mov    0x8(%edx),%ebx
80104115:	e8 d6 f4 ff ff       	call   801035f0 <mycpu>
8010411a:	39 c3                	cmp    %eax,%ebx
8010411c:	0f 94 c0             	sete   %al
8010411f:	0f b6 c0             	movzbl %al,%eax
}
80104122:	83 c4 04             	add    $0x4,%esp
80104125:	5b                   	pop    %ebx
80104126:	5d                   	pop    %ebp
80104127:	c3                   	ret    
80104128:	90                   	nop
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104130 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 04             	sub    $0x4,%esp
80104137:	9c                   	pushf  
80104138:	5b                   	pop    %ebx
  asm volatile("cli");
80104139:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010413a:	e8 b1 f4 ff ff       	call   801035f0 <mycpu>
8010413f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104145:	85 c0                	test   %eax,%eax
80104147:	75 11                	jne    8010415a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104149:	e8 a2 f4 ff ff       	call   801035f0 <mycpu>
8010414e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104154:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010415a:	e8 91 f4 ff ff       	call   801035f0 <mycpu>
8010415f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104166:	83 c4 04             	add    $0x4,%esp
80104169:	5b                   	pop    %ebx
8010416a:	5d                   	pop    %ebp
8010416b:	c3                   	ret    
8010416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104170 <acquire>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104177:	e8 b4 ff ff ff       	call   80104130 <pushcli>
  if(holding(lk))
8010417c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010417f:	8b 02                	mov    (%edx),%eax
80104181:	85 c0                	test   %eax,%eax
80104183:	75 43                	jne    801041c8 <acquire+0x58>
  asm volatile("lock; xchgl %0, %1" :
80104185:	b9 01 00 00 00       	mov    $0x1,%ecx
8010418a:	eb 07                	jmp    80104193 <acquire+0x23>
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104190:	8b 55 08             	mov    0x8(%ebp),%edx
80104193:	89 c8                	mov    %ecx,%eax
80104195:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
80104198:	85 c0                	test   %eax,%eax
8010419a:	75 f4                	jne    80104190 <acquire+0x20>
  __sync_synchronize();
8010419c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010419f:	8b 5d 08             	mov    0x8(%ebp),%ebx
801041a2:	e8 49 f4 ff ff       	call   801035f0 <mycpu>
801041a7:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801041aa:	8b 45 08             	mov    0x8(%ebp),%eax
801041ad:	83 c0 0c             	add    $0xc,%eax
801041b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801041b4:	8d 45 08             	lea    0x8(%ebp),%eax
801041b7:	89 04 24             	mov    %eax,(%esp)
801041ba:	e8 e1 fe ff ff       	call   801040a0 <getcallerpcs>
}
801041bf:	83 c4 14             	add    $0x14,%esp
801041c2:	5b                   	pop    %ebx
801041c3:	5d                   	pop    %ebp
801041c4:	c3                   	ret    
801041c5:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
801041c8:	8b 5a 08             	mov    0x8(%edx),%ebx
801041cb:	e8 20 f4 ff ff       	call   801035f0 <mycpu>
  if(holding(lk))
801041d0:	39 c3                	cmp    %eax,%ebx
801041d2:	74 05                	je     801041d9 <acquire+0x69>
801041d4:	8b 55 08             	mov    0x8(%ebp),%edx
801041d7:	eb ac                	jmp    80104185 <acquire+0x15>
    panic("acquire");
801041d9:	c7 04 24 a3 74 10 80 	movl   $0x801074a3,(%esp)
801041e0:	e8 7b c1 ff ff       	call   80100360 <panic>
801041e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041f0 <popcli>:

void
popcli(void)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041f6:	9c                   	pushf  
801041f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041f8:	f6 c4 02             	test   $0x2,%ah
801041fb:	75 49                	jne    80104246 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801041fd:	e8 ee f3 ff ff       	call   801035f0 <mycpu>
80104202:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104208:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010420b:	85 d2                	test   %edx,%edx
8010420d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104213:	78 25                	js     8010423a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104215:	e8 d6 f3 ff ff       	call   801035f0 <mycpu>
8010421a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104220:	85 d2                	test   %edx,%edx
80104222:	74 04                	je     80104228 <popcli+0x38>
    sti();
}
80104224:	c9                   	leave  
80104225:	c3                   	ret    
80104226:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104228:	e8 c3 f3 ff ff       	call   801035f0 <mycpu>
8010422d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104233:	85 c0                	test   %eax,%eax
80104235:	74 ed                	je     80104224 <popcli+0x34>
  asm volatile("sti");
80104237:	fb                   	sti    
}
80104238:	c9                   	leave  
80104239:	c3                   	ret    
    panic("popcli");
8010423a:	c7 04 24 c2 74 10 80 	movl   $0x801074c2,(%esp)
80104241:	e8 1a c1 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104246:	c7 04 24 ab 74 10 80 	movl   $0x801074ab,(%esp)
8010424d:	e8 0e c1 ff ff       	call   80100360 <panic>
80104252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104260 <release>:
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
80104265:	83 ec 10             	sub    $0x10,%esp
80104268:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010426b:	8b 03                	mov    (%ebx),%eax
8010426d:	85 c0                	test   %eax,%eax
8010426f:	75 0f                	jne    80104280 <release+0x20>
    panic("release");
80104271:	c7 04 24 c9 74 10 80 	movl   $0x801074c9,(%esp)
80104278:	e8 e3 c0 ff ff       	call   80100360 <panic>
8010427d:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104280:	8b 73 08             	mov    0x8(%ebx),%esi
80104283:	e8 68 f3 ff ff       	call   801035f0 <mycpu>
  if(!holding(lk))
80104288:	39 c6                	cmp    %eax,%esi
8010428a:	75 e5                	jne    80104271 <release+0x11>
  lk->pcs[0] = 0;
8010428c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104293:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010429a:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010429d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801042a3:	83 c4 10             	add    $0x10,%esp
801042a6:	5b                   	pop    %ebx
801042a7:	5e                   	pop    %esi
801042a8:	5d                   	pop    %ebp
  popcli();
801042a9:	e9 42 ff ff ff       	jmp    801041f0 <popcli>
801042ae:	66 90                	xchg   %ax,%ax

801042b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	8b 55 08             	mov    0x8(%ebp),%edx
801042b6:	57                   	push   %edi
801042b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801042ba:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801042bb:	f6 c2 03             	test   $0x3,%dl
801042be:	75 05                	jne    801042c5 <memset+0x15>
801042c0:	f6 c1 03             	test   $0x3,%cl
801042c3:	74 13                	je     801042d8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801042c5:	89 d7                	mov    %edx,%edi
801042c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ca:	fc                   	cld    
801042cb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801042cd:	5b                   	pop    %ebx
801042ce:	89 d0                	mov    %edx,%eax
801042d0:	5f                   	pop    %edi
801042d1:	5d                   	pop    %ebp
801042d2:	c3                   	ret    
801042d3:	90                   	nop
801042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801042d8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801042dc:	c1 e9 02             	shr    $0x2,%ecx
801042df:	89 f8                	mov    %edi,%eax
801042e1:	89 fb                	mov    %edi,%ebx
801042e3:	c1 e0 18             	shl    $0x18,%eax
801042e6:	c1 e3 10             	shl    $0x10,%ebx
801042e9:	09 d8                	or     %ebx,%eax
801042eb:	09 f8                	or     %edi,%eax
801042ed:	c1 e7 08             	shl    $0x8,%edi
801042f0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801042f2:	89 d7                	mov    %edx,%edi
801042f4:	fc                   	cld    
801042f5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801042f7:	5b                   	pop    %ebx
801042f8:	89 d0                	mov    %edx,%eax
801042fa:	5f                   	pop    %edi
801042fb:	5d                   	pop    %ebp
801042fc:	c3                   	ret    
801042fd:	8d 76 00             	lea    0x0(%esi),%esi

80104300 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	8b 45 10             	mov    0x10(%ebp),%eax
80104306:	57                   	push   %edi
80104307:	56                   	push   %esi
80104308:	8b 75 0c             	mov    0xc(%ebp),%esi
8010430b:	53                   	push   %ebx
8010430c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010430f:	85 c0                	test   %eax,%eax
80104311:	8d 78 ff             	lea    -0x1(%eax),%edi
80104314:	74 26                	je     8010433c <memcmp+0x3c>
    if(*s1 != *s2)
80104316:	0f b6 03             	movzbl (%ebx),%eax
80104319:	31 d2                	xor    %edx,%edx
8010431b:	0f b6 0e             	movzbl (%esi),%ecx
8010431e:	38 c8                	cmp    %cl,%al
80104320:	74 16                	je     80104338 <memcmp+0x38>
80104322:	eb 24                	jmp    80104348 <memcmp+0x48>
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104328:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010432d:	83 c2 01             	add    $0x1,%edx
80104330:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104334:	38 c8                	cmp    %cl,%al
80104336:	75 10                	jne    80104348 <memcmp+0x48>
  while(n-- > 0){
80104338:	39 fa                	cmp    %edi,%edx
8010433a:	75 ec                	jne    80104328 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010433c:	5b                   	pop    %ebx
  return 0;
8010433d:	31 c0                	xor    %eax,%eax
}
8010433f:	5e                   	pop    %esi
80104340:	5f                   	pop    %edi
80104341:	5d                   	pop    %ebp
80104342:	c3                   	ret    
80104343:	90                   	nop
80104344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104348:	5b                   	pop    %ebx
      return *s1 - *s2;
80104349:	29 c8                	sub    %ecx,%eax
}
8010434b:	5e                   	pop    %esi
8010434c:	5f                   	pop    %edi
8010434d:	5d                   	pop    %ebp
8010434e:	c3                   	ret    
8010434f:	90                   	nop

80104350 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	8b 45 08             	mov    0x8(%ebp),%eax
80104357:	56                   	push   %esi
80104358:	8b 75 0c             	mov    0xc(%ebp),%esi
8010435b:	53                   	push   %ebx
8010435c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010435f:	39 c6                	cmp    %eax,%esi
80104361:	73 35                	jae    80104398 <memmove+0x48>
80104363:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104366:	39 c8                	cmp    %ecx,%eax
80104368:	73 2e                	jae    80104398 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010436a:	85 db                	test   %ebx,%ebx
    d += n;
8010436c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010436f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104372:	74 1b                	je     8010438f <memmove+0x3f>
80104374:	f7 db                	neg    %ebx
80104376:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104379:	01 fb                	add    %edi,%ebx
8010437b:	90                   	nop
8010437c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104380:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104384:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104387:	83 ea 01             	sub    $0x1,%edx
8010438a:	83 fa ff             	cmp    $0xffffffff,%edx
8010438d:	75 f1                	jne    80104380 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010438f:	5b                   	pop    %ebx
80104390:	5e                   	pop    %esi
80104391:	5f                   	pop    %edi
80104392:	5d                   	pop    %ebp
80104393:	c3                   	ret    
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104398:	31 d2                	xor    %edx,%edx
8010439a:	85 db                	test   %ebx,%ebx
8010439c:	74 f1                	je     8010438f <memmove+0x3f>
8010439e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801043a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043a4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801043a7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801043aa:	39 da                	cmp    %ebx,%edx
801043ac:	75 f2                	jne    801043a0 <memmove+0x50>
}
801043ae:	5b                   	pop    %ebx
801043af:	5e                   	pop    %esi
801043b0:	5f                   	pop    %edi
801043b1:	5d                   	pop    %ebp
801043b2:	c3                   	ret    
801043b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801043c3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801043c4:	eb 8a                	jmp    80104350 <memmove>
801043c6:	8d 76 00             	lea    0x0(%esi),%esi
801043c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043d0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	56                   	push   %esi
801043d4:	8b 75 10             	mov    0x10(%ebp),%esi
801043d7:	53                   	push   %ebx
801043d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801043de:	85 f6                	test   %esi,%esi
801043e0:	74 30                	je     80104412 <strncmp+0x42>
801043e2:	0f b6 01             	movzbl (%ecx),%eax
801043e5:	84 c0                	test   %al,%al
801043e7:	74 2f                	je     80104418 <strncmp+0x48>
801043e9:	0f b6 13             	movzbl (%ebx),%edx
801043ec:	38 d0                	cmp    %dl,%al
801043ee:	75 46                	jne    80104436 <strncmp+0x66>
801043f0:	8d 51 01             	lea    0x1(%ecx),%edx
801043f3:	01 ce                	add    %ecx,%esi
801043f5:	eb 14                	jmp    8010440b <strncmp+0x3b>
801043f7:	90                   	nop
801043f8:	0f b6 02             	movzbl (%edx),%eax
801043fb:	84 c0                	test   %al,%al
801043fd:	74 31                	je     80104430 <strncmp+0x60>
801043ff:	0f b6 19             	movzbl (%ecx),%ebx
80104402:	83 c2 01             	add    $0x1,%edx
80104405:	38 d8                	cmp    %bl,%al
80104407:	75 17                	jne    80104420 <strncmp+0x50>
    n--, p++, q++;
80104409:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
8010440b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010440d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
80104410:	75 e6                	jne    801043f8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104412:	5b                   	pop    %ebx
    return 0;
80104413:	31 c0                	xor    %eax,%eax
}
80104415:	5e                   	pop    %esi
80104416:	5d                   	pop    %ebp
80104417:	c3                   	ret    
80104418:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
8010441b:	31 c0                	xor    %eax,%eax
8010441d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104420:	0f b6 d3             	movzbl %bl,%edx
80104423:	29 d0                	sub    %edx,%eax
}
80104425:	5b                   	pop    %ebx
80104426:	5e                   	pop    %esi
80104427:	5d                   	pop    %ebp
80104428:	c3                   	ret    
80104429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104430:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104434:	eb ea                	jmp    80104420 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104436:	89 d3                	mov    %edx,%ebx
80104438:	eb e6                	jmp    80104420 <strncmp+0x50>
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	8b 45 08             	mov    0x8(%ebp),%eax
80104446:	56                   	push   %esi
80104447:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010444a:	53                   	push   %ebx
8010444b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010444e:	89 c2                	mov    %eax,%edx
80104450:	eb 19                	jmp    8010446b <strncpy+0x2b>
80104452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104458:	83 c3 01             	add    $0x1,%ebx
8010445b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010445f:	83 c2 01             	add    $0x1,%edx
80104462:	84 c9                	test   %cl,%cl
80104464:	88 4a ff             	mov    %cl,-0x1(%edx)
80104467:	74 09                	je     80104472 <strncpy+0x32>
80104469:	89 f1                	mov    %esi,%ecx
8010446b:	85 c9                	test   %ecx,%ecx
8010446d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104470:	7f e6                	jg     80104458 <strncpy+0x18>
    ;
  while(n-- > 0)
80104472:	31 c9                	xor    %ecx,%ecx
80104474:	85 f6                	test   %esi,%esi
80104476:	7e 0f                	jle    80104487 <strncpy+0x47>
    *s++ = 0;
80104478:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010447c:	89 f3                	mov    %esi,%ebx
8010447e:	83 c1 01             	add    $0x1,%ecx
80104481:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104483:	85 db                	test   %ebx,%ebx
80104485:	7f f1                	jg     80104478 <strncpy+0x38>
  return os;
}
80104487:	5b                   	pop    %ebx
80104488:	5e                   	pop    %esi
80104489:	5d                   	pop    %ebp
8010448a:	c3                   	ret    
8010448b:	90                   	nop
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104490 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104496:	56                   	push   %esi
80104497:	8b 45 08             	mov    0x8(%ebp),%eax
8010449a:	53                   	push   %ebx
8010449b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010449e:	85 c9                	test   %ecx,%ecx
801044a0:	7e 26                	jle    801044c8 <safestrcpy+0x38>
801044a2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801044a6:	89 c1                	mov    %eax,%ecx
801044a8:	eb 17                	jmp    801044c1 <safestrcpy+0x31>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044b0:	83 c2 01             	add    $0x1,%edx
801044b3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801044b7:	83 c1 01             	add    $0x1,%ecx
801044ba:	84 db                	test   %bl,%bl
801044bc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044bf:	74 04                	je     801044c5 <safestrcpy+0x35>
801044c1:	39 f2                	cmp    %esi,%edx
801044c3:	75 eb                	jne    801044b0 <safestrcpy+0x20>
    ;
  *s = 0;
801044c5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044c8:	5b                   	pop    %ebx
801044c9:	5e                   	pop    %esi
801044ca:	5d                   	pop    %ebp
801044cb:	c3                   	ret    
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044d0 <strlen>:

int
strlen(const char *s)
{
801044d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801044d1:	31 c0                	xor    %eax,%eax
{
801044d3:	89 e5                	mov    %esp,%ebp
801044d5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801044d8:	80 3a 00             	cmpb   $0x0,(%edx)
801044db:	74 0c                	je     801044e9 <strlen+0x19>
801044dd:	8d 76 00             	lea    0x0(%esi),%esi
801044e0:	83 c0 01             	add    $0x1,%eax
801044e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044e7:	75 f7                	jne    801044e0 <strlen+0x10>
    ;
  return n;
}
801044e9:	5d                   	pop    %ebp
801044ea:	c3                   	ret    

801044eb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044eb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044ef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801044f3:	55                   	push   %ebp
  pushl %ebx
801044f4:	53                   	push   %ebx
  pushl %esi
801044f5:	56                   	push   %esi
  pushl %edi
801044f6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044f7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044f9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801044fb:	5f                   	pop    %edi
  popl %esi
801044fc:	5e                   	pop    %esi
  popl %ebx
801044fd:	5b                   	pop    %ebx
  popl %ebp
801044fe:	5d                   	pop    %ebp
  ret
801044ff:	c3                   	ret    

80104500 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	53                   	push   %ebx
80104504:	83 ec 04             	sub    $0x4,%esp
80104507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010450a:	e8 81 f1 ff ff       	call   80103690 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010450f:	8b 00                	mov    (%eax),%eax
80104511:	39 d8                	cmp    %ebx,%eax
80104513:	76 1b                	jbe    80104530 <fetchint+0x30>
80104515:	8d 53 04             	lea    0x4(%ebx),%edx
80104518:	39 d0                	cmp    %edx,%eax
8010451a:	72 14                	jb     80104530 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010451c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010451f:	8b 13                	mov    (%ebx),%edx
80104521:	89 10                	mov    %edx,(%eax)
  return 0;
80104523:	31 c0                	xor    %eax,%eax
}
80104525:	83 c4 04             	add    $0x4,%esp
80104528:	5b                   	pop    %ebx
80104529:	5d                   	pop    %ebp
8010452a:	c3                   	ret    
8010452b:	90                   	nop
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104535:	eb ee                	jmp    80104525 <fetchint+0x25>
80104537:	89 f6                	mov    %esi,%esi
80104539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104540 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 04             	sub    $0x4,%esp
80104547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010454a:	e8 41 f1 ff ff       	call   80103690 <myproc>

  if(addr >= curproc->sz)
8010454f:	39 18                	cmp    %ebx,(%eax)
80104551:	76 26                	jbe    80104579 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104553:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104556:	89 da                	mov    %ebx,%edx
80104558:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010455a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010455c:	39 c3                	cmp    %eax,%ebx
8010455e:	73 19                	jae    80104579 <fetchstr+0x39>
    if(*s == 0)
80104560:	80 3b 00             	cmpb   $0x0,(%ebx)
80104563:	75 0d                	jne    80104572 <fetchstr+0x32>
80104565:	eb 21                	jmp    80104588 <fetchstr+0x48>
80104567:	90                   	nop
80104568:	80 3a 00             	cmpb   $0x0,(%edx)
8010456b:	90                   	nop
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104570:	74 16                	je     80104588 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80104572:	83 c2 01             	add    $0x1,%edx
80104575:	39 d0                	cmp    %edx,%eax
80104577:	77 ef                	ja     80104568 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
80104579:	83 c4 04             	add    $0x4,%esp
    return -1;
8010457c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104581:	5b                   	pop    %ebx
80104582:	5d                   	pop    %ebp
80104583:	c3                   	ret    
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104588:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010458b:	89 d0                	mov    %edx,%eax
8010458d:	29 d8                	sub    %ebx,%eax
}
8010458f:	5b                   	pop    %ebx
80104590:	5d                   	pop    %ebp
80104591:	c3                   	ret    
80104592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	8b 75 0c             	mov    0xc(%ebp),%esi
801045a7:	53                   	push   %ebx
801045a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045ab:	e8 e0 f0 ff ff       	call   80103690 <myproc>
801045b0:	89 75 0c             	mov    %esi,0xc(%ebp)
801045b3:	8b 40 20             	mov    0x20(%eax),%eax
801045b6:	8b 40 44             	mov    0x44(%eax),%eax
801045b9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801045bd:	89 45 08             	mov    %eax,0x8(%ebp)
}
801045c0:	5b                   	pop    %ebx
801045c1:	5e                   	pop    %esi
801045c2:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045c3:	e9 38 ff ff ff       	jmp    80104500 <fetchint>
801045c8:	90                   	nop
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	83 ec 20             	sub    $0x20,%esp
801045d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801045db:	e8 b0 f0 ff ff       	call   80103690 <myproc>
801045e0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801045e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801045e9:	8b 45 08             	mov    0x8(%ebp),%eax
801045ec:	89 04 24             	mov    %eax,(%esp)
801045ef:	e8 ac ff ff ff       	call   801045a0 <argint>
801045f4:	85 c0                	test   %eax,%eax
801045f6:	78 28                	js     80104620 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801045f8:	85 db                	test   %ebx,%ebx
801045fa:	78 24                	js     80104620 <argptr+0x50>
801045fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ff:	8b 06                	mov    (%esi),%eax
80104601:	39 c2                	cmp    %eax,%edx
80104603:	73 1b                	jae    80104620 <argptr+0x50>
80104605:	01 d3                	add    %edx,%ebx
80104607:	39 d8                	cmp    %ebx,%eax
80104609:	72 15                	jb     80104620 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010460b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010460e:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104610:	83 c4 20             	add    $0x20,%esp
  return 0;
80104613:	31 c0                	xor    %eax,%eax
}
80104615:	5b                   	pop    %ebx
80104616:	5e                   	pop    %esi
80104617:	5d                   	pop    %ebp
80104618:	c3                   	ret    
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104620:	83 c4 20             	add    $0x20,%esp
    return -1;
80104623:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104628:	5b                   	pop    %ebx
80104629:	5e                   	pop    %esi
8010462a:	5d                   	pop    %ebp
8010462b:	c3                   	ret    
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104636:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104639:	89 44 24 04          	mov    %eax,0x4(%esp)
8010463d:	8b 45 08             	mov    0x8(%ebp),%eax
80104640:	89 04 24             	mov    %eax,(%esp)
80104643:	e8 58 ff ff ff       	call   801045a0 <argint>
80104648:	85 c0                	test   %eax,%eax
8010464a:	78 14                	js     80104660 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010464c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010464f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104656:	89 04 24             	mov    %eax,(%esp)
80104659:	e8 e2 fe ff ff       	call   80104540 <fetchstr>
}
8010465e:	c9                   	leave  
8010465f:	c3                   	ret    
    return -1;
80104660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104665:	c9                   	leave  
80104666:	c3                   	ret    
80104667:	89 f6                	mov    %esi,%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104670 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104678:	e8 13 f0 ff ff       	call   80103690 <myproc>

  num = curproc->tf->eax;
8010467d:	8b 70 20             	mov    0x20(%eax),%esi
  struct proc *curproc = myproc();
80104680:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104682:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104685:	8d 50 ff             	lea    -0x1(%eax),%edx
80104688:	83 fa 16             	cmp    $0x16,%edx
8010468b:	77 1b                	ja     801046a8 <syscall+0x38>
8010468d:	8b 14 85 00 75 10 80 	mov    -0x7fef8b00(,%eax,4),%edx
80104694:	85 d2                	test   %edx,%edx
80104696:	74 10                	je     801046a8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104698:	ff d2                	call   *%edx
8010469a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010469d:	83 c4 10             	add    $0x10,%esp
801046a0:	5b                   	pop    %ebx
801046a1:	5e                   	pop    %esi
801046a2:	5d                   	pop    %ebp
801046a3:	c3                   	ret    
801046a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801046a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801046ac:	8d 43 74             	lea    0x74(%ebx),%eax
801046af:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
801046b3:	8b 43 18             	mov    0x18(%ebx),%eax
801046b6:	c7 04 24 d1 74 10 80 	movl   $0x801074d1,(%esp)
801046bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801046c1:	e8 8a bf ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
801046c6:	8b 43 20             	mov    0x20(%ebx),%eax
801046c9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801046d0:	83 c4 10             	add    $0x10,%esp
801046d3:	5b                   	pop    %ebx
801046d4:	5e                   	pop    %esi
801046d5:	5d                   	pop    %ebp
801046d6:	c3                   	ret    
801046d7:	66 90                	xchg   %ax,%ax
801046d9:	66 90                	xchg   %ax,%ax
801046db:	66 90                	xchg   %ax,%ax
801046dd:	66 90                	xchg   %ax,%ax
801046df:	90                   	nop

801046e0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	53                   	push   %ebx
801046e4:	89 c3                	mov    %eax,%ebx
801046e6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801046e9:	e8 a2 ef ff ff       	call   80103690 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801046ee:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
801046f0:	8b 4c 90 30          	mov    0x30(%eax,%edx,4),%ecx
801046f4:	85 c9                	test   %ecx,%ecx
801046f6:	74 18                	je     80104710 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
801046f8:	83 c2 01             	add    $0x1,%edx
801046fb:	83 fa 10             	cmp    $0x10,%edx
801046fe:	75 f0                	jne    801046f0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104700:	83 c4 04             	add    $0x4,%esp
  return -1;
80104703:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104708:	5b                   	pop    %ebx
80104709:	5d                   	pop    %ebp
8010470a:	c3                   	ret    
8010470b:	90                   	nop
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104710:	89 5c 90 30          	mov    %ebx,0x30(%eax,%edx,4)
}
80104714:	83 c4 04             	add    $0x4,%esp
      return fd;
80104717:	89 d0                	mov    %edx,%eax
}
80104719:	5b                   	pop    %ebx
8010471a:	5d                   	pop    %ebp
8010471b:	c3                   	ret    
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	57                   	push   %edi
80104724:	56                   	push   %esi
80104725:	53                   	push   %ebx
80104726:	83 ec 4c             	sub    $0x4c,%esp
80104729:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010472c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010472f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104732:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104736:	89 04 24             	mov    %eax,(%esp)
{
80104739:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010473c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010473f:	e8 cc d7 ff ff       	call   80101f10 <nameiparent>
80104744:	85 c0                	test   %eax,%eax
80104746:	89 c7                	mov    %eax,%edi
80104748:	0f 84 da 00 00 00    	je     80104828 <create+0x108>
    return 0;
  ilock(dp);
8010474e:	89 04 24             	mov    %eax,(%esp)
80104751:	e8 4a cf ff ff       	call   801016a0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104756:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104759:	89 44 24 08          	mov    %eax,0x8(%esp)
8010475d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104761:	89 3c 24             	mov    %edi,(%esp)
80104764:	e8 47 d4 ff ff       	call   80101bb0 <dirlookup>
80104769:	85 c0                	test   %eax,%eax
8010476b:	89 c6                	mov    %eax,%esi
8010476d:	74 41                	je     801047b0 <create+0x90>
    iunlockput(dp);
8010476f:	89 3c 24             	mov    %edi,(%esp)
80104772:	e8 89 d1 ff ff       	call   80101900 <iunlockput>
    ilock(ip);
80104777:	89 34 24             	mov    %esi,(%esp)
8010477a:	e8 21 cf ff ff       	call   801016a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010477f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104784:	75 12                	jne    80104798 <create+0x78>
80104786:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010478b:	89 f0                	mov    %esi,%eax
8010478d:	75 09                	jne    80104798 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010478f:	83 c4 4c             	add    $0x4c,%esp
80104792:	5b                   	pop    %ebx
80104793:	5e                   	pop    %esi
80104794:	5f                   	pop    %edi
80104795:	5d                   	pop    %ebp
80104796:	c3                   	ret    
80104797:	90                   	nop
    iunlockput(ip);
80104798:	89 34 24             	mov    %esi,(%esp)
8010479b:	e8 60 d1 ff ff       	call   80101900 <iunlockput>
}
801047a0:	83 c4 4c             	add    $0x4c,%esp
    return 0;
801047a3:	31 c0                	xor    %eax,%eax
}
801047a5:	5b                   	pop    %ebx
801047a6:	5e                   	pop    %esi
801047a7:	5f                   	pop    %edi
801047a8:	5d                   	pop    %ebp
801047a9:	c3                   	ret    
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801047b0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801047b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801047b8:	8b 07                	mov    (%edi),%eax
801047ba:	89 04 24             	mov    %eax,(%esp)
801047bd:	e8 4e cd ff ff       	call   80101510 <ialloc>
801047c2:	85 c0                	test   %eax,%eax
801047c4:	89 c6                	mov    %eax,%esi
801047c6:	0f 84 bf 00 00 00    	je     8010488b <create+0x16b>
  ilock(ip);
801047cc:	89 04 24             	mov    %eax,(%esp)
801047cf:	e8 cc ce ff ff       	call   801016a0 <ilock>
  ip->major = major;
801047d4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801047d8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801047dc:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801047e0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801047e4:	b8 01 00 00 00       	mov    $0x1,%eax
801047e9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801047ed:	89 34 24             	mov    %esi,(%esp)
801047f0:	e8 eb cd ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801047f5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801047fa:	74 34                	je     80104830 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801047fc:	8b 46 04             	mov    0x4(%esi),%eax
801047ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104803:	89 3c 24             	mov    %edi,(%esp)
80104806:	89 44 24 08          	mov    %eax,0x8(%esp)
8010480a:	e8 01 d6 ff ff       	call   80101e10 <dirlink>
8010480f:	85 c0                	test   %eax,%eax
80104811:	78 6c                	js     8010487f <create+0x15f>
  iunlockput(dp);
80104813:	89 3c 24             	mov    %edi,(%esp)
80104816:	e8 e5 d0 ff ff       	call   80101900 <iunlockput>
}
8010481b:	83 c4 4c             	add    $0x4c,%esp
  return ip;
8010481e:	89 f0                	mov    %esi,%eax
}
80104820:	5b                   	pop    %ebx
80104821:	5e                   	pop    %esi
80104822:	5f                   	pop    %edi
80104823:	5d                   	pop    %ebp
80104824:	c3                   	ret    
80104825:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80104828:	31 c0                	xor    %eax,%eax
8010482a:	e9 60 ff ff ff       	jmp    8010478f <create+0x6f>
8010482f:	90                   	nop
    dp->nlink++;  // for ".."
80104830:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104835:	89 3c 24             	mov    %edi,(%esp)
80104838:	e8 a3 cd ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010483d:	8b 46 04             	mov    0x4(%esi),%eax
80104840:	c7 44 24 04 7c 75 10 	movl   $0x8010757c,0x4(%esp)
80104847:	80 
80104848:	89 34 24             	mov    %esi,(%esp)
8010484b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010484f:	e8 bc d5 ff ff       	call   80101e10 <dirlink>
80104854:	85 c0                	test   %eax,%eax
80104856:	78 1b                	js     80104873 <create+0x153>
80104858:	8b 47 04             	mov    0x4(%edi),%eax
8010485b:	c7 44 24 04 7b 75 10 	movl   $0x8010757b,0x4(%esp)
80104862:	80 
80104863:	89 34 24             	mov    %esi,(%esp)
80104866:	89 44 24 08          	mov    %eax,0x8(%esp)
8010486a:	e8 a1 d5 ff ff       	call   80101e10 <dirlink>
8010486f:	85 c0                	test   %eax,%eax
80104871:	79 89                	jns    801047fc <create+0xdc>
      panic("create dots");
80104873:	c7 04 24 6f 75 10 80 	movl   $0x8010756f,(%esp)
8010487a:	e8 e1 ba ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010487f:	c7 04 24 7e 75 10 80 	movl   $0x8010757e,(%esp)
80104886:	e8 d5 ba ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010488b:	c7 04 24 60 75 10 80 	movl   $0x80107560,(%esp)
80104892:	e8 c9 ba ff ff       	call   80100360 <panic>
80104897:	89 f6                	mov    %esi,%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048a0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	89 c6                	mov    %eax,%esi
801048a6:	53                   	push   %ebx
801048a7:	89 d3                	mov    %edx,%ebx
801048a9:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
801048ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048af:	89 44 24 04          	mov    %eax,0x4(%esp)
801048b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048ba:	e8 e1 fc ff ff       	call   801045a0 <argint>
801048bf:	85 c0                	test   %eax,%eax
801048c1:	78 2d                	js     801048f0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801048c3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048c7:	77 27                	ja     801048f0 <argfd.constprop.0+0x50>
801048c9:	e8 c2 ed ff ff       	call   80103690 <myproc>
801048ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048d1:	8b 44 90 30          	mov    0x30(%eax,%edx,4),%eax
801048d5:	85 c0                	test   %eax,%eax
801048d7:	74 17                	je     801048f0 <argfd.constprop.0+0x50>
  if(pfd)
801048d9:	85 f6                	test   %esi,%esi
801048db:	74 02                	je     801048df <argfd.constprop.0+0x3f>
    *pfd = fd;
801048dd:	89 16                	mov    %edx,(%esi)
  if(pf)
801048df:	85 db                	test   %ebx,%ebx
801048e1:	74 1d                	je     80104900 <argfd.constprop.0+0x60>
    *pf = f;
801048e3:	89 03                	mov    %eax,(%ebx)
  return 0;
801048e5:	31 c0                	xor    %eax,%eax
}
801048e7:	83 c4 20             	add    $0x20,%esp
801048ea:	5b                   	pop    %ebx
801048eb:	5e                   	pop    %esi
801048ec:	5d                   	pop    %ebp
801048ed:	c3                   	ret    
801048ee:	66 90                	xchg   %ax,%ax
801048f0:	83 c4 20             	add    $0x20,%esp
    return -1;
801048f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048f8:	5b                   	pop    %ebx
801048f9:	5e                   	pop    %esi
801048fa:	5d                   	pop    %ebp
801048fb:	c3                   	ret    
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104900:	31 c0                	xor    %eax,%eax
80104902:	eb e3                	jmp    801048e7 <argfd.constprop.0+0x47>
80104904:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010490a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104910 <sys_dup>:
{
80104910:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104911:	31 c0                	xor    %eax,%eax
{
80104913:	89 e5                	mov    %esp,%ebp
80104915:	53                   	push   %ebx
80104916:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104919:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010491c:	e8 7f ff ff ff       	call   801048a0 <argfd.constprop.0>
80104921:	85 c0                	test   %eax,%eax
80104923:	78 23                	js     80104948 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104928:	e8 b3 fd ff ff       	call   801046e0 <fdalloc>
8010492d:	85 c0                	test   %eax,%eax
8010492f:	89 c3                	mov    %eax,%ebx
80104931:	78 15                	js     80104948 <sys_dup+0x38>
  filedup(f);
80104933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104936:	89 04 24             	mov    %eax,(%esp)
80104939:	e8 82 c4 ff ff       	call   80100dc0 <filedup>
  return fd;
8010493e:	89 d8                	mov    %ebx,%eax
}
80104940:	83 c4 24             	add    $0x24,%esp
80104943:	5b                   	pop    %ebx
80104944:	5d                   	pop    %ebp
80104945:	c3                   	ret    
80104946:	66 90                	xchg   %ax,%ax
    return -1;
80104948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010494d:	eb f1                	jmp    80104940 <sys_dup+0x30>
8010494f:	90                   	nop

80104950 <sys_read>:
{
80104950:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104951:	31 c0                	xor    %eax,%eax
{
80104953:	89 e5                	mov    %esp,%ebp
80104955:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104958:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010495b:	e8 40 ff ff ff       	call   801048a0 <argfd.constprop.0>
80104960:	85 c0                	test   %eax,%eax
80104962:	78 54                	js     801049b8 <sys_read+0x68>
80104964:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104967:	89 44 24 04          	mov    %eax,0x4(%esp)
8010496b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104972:	e8 29 fc ff ff       	call   801045a0 <argint>
80104977:	85 c0                	test   %eax,%eax
80104979:	78 3d                	js     801049b8 <sys_read+0x68>
8010497b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010497e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104985:	89 44 24 08          	mov    %eax,0x8(%esp)
80104989:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010498c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104990:	e8 3b fc ff ff       	call   801045d0 <argptr>
80104995:	85 c0                	test   %eax,%eax
80104997:	78 1f                	js     801049b8 <sys_read+0x68>
  return fileread(f, p, n);
80104999:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010499c:	89 44 24 08          	mov    %eax,0x8(%esp)
801049a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801049a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049aa:	89 04 24             	mov    %eax,(%esp)
801049ad:	e8 6e c5 ff ff       	call   80100f20 <fileread>
}
801049b2:	c9                   	leave  
801049b3:	c3                   	ret    
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049bd:	c9                   	leave  
801049be:	c3                   	ret    
801049bf:	90                   	nop

801049c0 <sys_write>:
{
801049c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049c1:	31 c0                	xor    %eax,%eax
{
801049c3:	89 e5                	mov    %esp,%ebp
801049c5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801049cb:	e8 d0 fe ff ff       	call   801048a0 <argfd.constprop.0>
801049d0:	85 c0                	test   %eax,%eax
801049d2:	78 54                	js     80104a28 <sys_write+0x68>
801049d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801049db:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801049e2:	e8 b9 fb ff ff       	call   801045a0 <argint>
801049e7:	85 c0                	test   %eax,%eax
801049e9:	78 3d                	js     80104a28 <sys_write+0x68>
801049eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049f5:	89 44 24 08          	mov    %eax,0x8(%esp)
801049f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a00:	e8 cb fb ff ff       	call   801045d0 <argptr>
80104a05:	85 c0                	test   %eax,%eax
80104a07:	78 1f                	js     80104a28 <sys_write+0x68>
  return filewrite(f, p, n);
80104a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a13:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a1a:	89 04 24             	mov    %eax,(%esp)
80104a1d:	e8 9e c5 ff ff       	call   80100fc0 <filewrite>
}
80104a22:	c9                   	leave  
80104a23:	c3                   	ret    
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a2d:	c9                   	leave  
80104a2e:	c3                   	ret    
80104a2f:	90                   	nop

80104a30 <sys_close>:
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104a36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a3c:	e8 5f fe ff ff       	call   801048a0 <argfd.constprop.0>
80104a41:	85 c0                	test   %eax,%eax
80104a43:	78 23                	js     80104a68 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104a45:	e8 46 ec ff ff       	call   80103690 <myproc>
80104a4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a4d:	c7 44 90 30 00 00 00 	movl   $0x0,0x30(%eax,%edx,4)
80104a54:	00 
  fileclose(f);
80104a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a58:	89 04 24             	mov    %eax,(%esp)
80104a5b:	e8 b0 c3 ff ff       	call   80100e10 <fileclose>
  return 0;
80104a60:	31 c0                	xor    %eax,%eax
}
80104a62:	c9                   	leave  
80104a63:	c3                   	ret    
80104a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a6d:	c9                   	leave  
80104a6e:	c3                   	ret    
80104a6f:	90                   	nop

80104a70 <sys_fstat>:
{
80104a70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a71:	31 c0                	xor    %eax,%eax
{
80104a73:	89 e5                	mov    %esp,%ebp
80104a75:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a78:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a7b:	e8 20 fe ff ff       	call   801048a0 <argfd.constprop.0>
80104a80:	85 c0                	test   %eax,%eax
80104a82:	78 34                	js     80104ab8 <sys_fstat+0x48>
80104a84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a87:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a8e:	00 
80104a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a9a:	e8 31 fb ff ff       	call   801045d0 <argptr>
80104a9f:	85 c0                	test   %eax,%eax
80104aa1:	78 15                	js     80104ab8 <sys_fstat+0x48>
  return filestat(f, st);
80104aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aad:	89 04 24             	mov    %eax,(%esp)
80104ab0:	e8 1b c4 ff ff       	call   80100ed0 <filestat>
}
80104ab5:	c9                   	leave  
80104ab6:	c3                   	ret    
80104ab7:	90                   	nop
    return -1;
80104ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104abd:	c9                   	leave  
80104abe:	c3                   	ret    
80104abf:	90                   	nop

80104ac0 <sys_link>:
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ac9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ad0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ad7:	e8 54 fb ff ff       	call   80104630 <argstr>
80104adc:	85 c0                	test   %eax,%eax
80104ade:	0f 88 e6 00 00 00    	js     80104bca <sys_link+0x10a>
80104ae4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aeb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104af2:	e8 39 fb ff ff       	call   80104630 <argstr>
80104af7:	85 c0                	test   %eax,%eax
80104af9:	0f 88 cb 00 00 00    	js     80104bca <sys_link+0x10a>
  begin_op();
80104aff:	e8 fc df ff ff       	call   80102b00 <begin_op>
  if((ip = namei(old)) == 0){
80104b04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b07:	89 04 24             	mov    %eax,(%esp)
80104b0a:	e8 e1 d3 ff ff       	call   80101ef0 <namei>
80104b0f:	85 c0                	test   %eax,%eax
80104b11:	89 c3                	mov    %eax,%ebx
80104b13:	0f 84 ac 00 00 00    	je     80104bc5 <sys_link+0x105>
  ilock(ip);
80104b19:	89 04 24             	mov    %eax,(%esp)
80104b1c:	e8 7f cb ff ff       	call   801016a0 <ilock>
  if(ip->type == T_DIR){
80104b21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b26:	0f 84 91 00 00 00    	je     80104bbd <sys_link+0xfd>
  ip->nlink++;
80104b2c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104b31:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104b34:	89 1c 24             	mov    %ebx,(%esp)
80104b37:	e8 a4 ca ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104b3c:	89 1c 24             	mov    %ebx,(%esp)
80104b3f:	e8 3c cc ff ff       	call   80101780 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104b44:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b47:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b4b:	89 04 24             	mov    %eax,(%esp)
80104b4e:	e8 bd d3 ff ff       	call   80101f10 <nameiparent>
80104b53:	85 c0                	test   %eax,%eax
80104b55:	89 c6                	mov    %eax,%esi
80104b57:	74 4f                	je     80104ba8 <sys_link+0xe8>
  ilock(dp);
80104b59:	89 04 24             	mov    %eax,(%esp)
80104b5c:	e8 3f cb ff ff       	call   801016a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104b61:	8b 03                	mov    (%ebx),%eax
80104b63:	39 06                	cmp    %eax,(%esi)
80104b65:	75 39                	jne    80104ba0 <sys_link+0xe0>
80104b67:	8b 43 04             	mov    0x4(%ebx),%eax
80104b6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b6e:	89 34 24             	mov    %esi,(%esp)
80104b71:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b75:	e8 96 d2 ff ff       	call   80101e10 <dirlink>
80104b7a:	85 c0                	test   %eax,%eax
80104b7c:	78 22                	js     80104ba0 <sys_link+0xe0>
  iunlockput(dp);
80104b7e:	89 34 24             	mov    %esi,(%esp)
80104b81:	e8 7a cd ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104b86:	89 1c 24             	mov    %ebx,(%esp)
80104b89:	e8 32 cc ff ff       	call   801017c0 <iput>
  end_op();
80104b8e:	e8 dd df ff ff       	call   80102b70 <end_op>
}
80104b93:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104b96:	31 c0                	xor    %eax,%eax
}
80104b98:	5b                   	pop    %ebx
80104b99:	5e                   	pop    %esi
80104b9a:	5f                   	pop    %edi
80104b9b:	5d                   	pop    %ebp
80104b9c:	c3                   	ret    
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104ba0:	89 34 24             	mov    %esi,(%esp)
80104ba3:	e8 58 cd ff ff       	call   80101900 <iunlockput>
  ilock(ip);
80104ba8:	89 1c 24             	mov    %ebx,(%esp)
80104bab:	e8 f0 ca ff ff       	call   801016a0 <ilock>
  ip->nlink--;
80104bb0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104bb5:	89 1c 24             	mov    %ebx,(%esp)
80104bb8:	e8 23 ca ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104bbd:	89 1c 24             	mov    %ebx,(%esp)
80104bc0:	e8 3b cd ff ff       	call   80101900 <iunlockput>
  end_op();
80104bc5:	e8 a6 df ff ff       	call   80102b70 <end_op>
}
80104bca:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104bcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bd2:	5b                   	pop    %ebx
80104bd3:	5e                   	pop    %esi
80104bd4:	5f                   	pop    %edi
80104bd5:	5d                   	pop    %ebp
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <sys_unlink>:
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	57                   	push   %edi
80104be4:	56                   	push   %esi
80104be5:	53                   	push   %ebx
80104be6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104be9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104bec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bf0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104bf7:	e8 34 fa ff ff       	call   80104630 <argstr>
80104bfc:	85 c0                	test   %eax,%eax
80104bfe:	0f 88 76 01 00 00    	js     80104d7a <sys_unlink+0x19a>
  begin_op();
80104c04:	e8 f7 de ff ff       	call   80102b00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104c09:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104c0c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104c0f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c13:	89 04 24             	mov    %eax,(%esp)
80104c16:	e8 f5 d2 ff ff       	call   80101f10 <nameiparent>
80104c1b:	85 c0                	test   %eax,%eax
80104c1d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104c20:	0f 84 4f 01 00 00    	je     80104d75 <sys_unlink+0x195>
  ilock(dp);
80104c26:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104c29:	89 34 24             	mov    %esi,(%esp)
80104c2c:	e8 6f ca ff ff       	call   801016a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104c31:	c7 44 24 04 7c 75 10 	movl   $0x8010757c,0x4(%esp)
80104c38:	80 
80104c39:	89 1c 24             	mov    %ebx,(%esp)
80104c3c:	e8 3f cf ff ff       	call   80101b80 <namecmp>
80104c41:	85 c0                	test   %eax,%eax
80104c43:	0f 84 21 01 00 00    	je     80104d6a <sys_unlink+0x18a>
80104c49:	c7 44 24 04 7b 75 10 	movl   $0x8010757b,0x4(%esp)
80104c50:	80 
80104c51:	89 1c 24             	mov    %ebx,(%esp)
80104c54:	e8 27 cf ff ff       	call   80101b80 <namecmp>
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	0f 84 09 01 00 00    	je     80104d6a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104c61:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c68:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c6c:	89 34 24             	mov    %esi,(%esp)
80104c6f:	e8 3c cf ff ff       	call   80101bb0 <dirlookup>
80104c74:	85 c0                	test   %eax,%eax
80104c76:	89 c3                	mov    %eax,%ebx
80104c78:	0f 84 ec 00 00 00    	je     80104d6a <sys_unlink+0x18a>
  ilock(ip);
80104c7e:	89 04 24             	mov    %eax,(%esp)
80104c81:	e8 1a ca ff ff       	call   801016a0 <ilock>
  if(ip->nlink < 1)
80104c86:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c8b:	0f 8e 24 01 00 00    	jle    80104db5 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c96:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c99:	74 7d                	je     80104d18 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104c9b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104ca2:	00 
80104ca3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104caa:	00 
80104cab:	89 34 24             	mov    %esi,(%esp)
80104cae:	e8 fd f5 ff ff       	call   801042b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cb3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104cb6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104cbd:	00 
80104cbe:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cc2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cc6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cc9:	89 04 24             	mov    %eax,(%esp)
80104ccc:	e8 7f cd ff ff       	call   80101a50 <writei>
80104cd1:	83 f8 10             	cmp    $0x10,%eax
80104cd4:	0f 85 cf 00 00 00    	jne    80104da9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104cda:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104cdf:	0f 84 a3 00 00 00    	je     80104d88 <sys_unlink+0x1a8>
  iunlockput(dp);
80104ce5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104ce8:	89 04 24             	mov    %eax,(%esp)
80104ceb:	e8 10 cc ff ff       	call   80101900 <iunlockput>
  ip->nlink--;
80104cf0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104cf5:	89 1c 24             	mov    %ebx,(%esp)
80104cf8:	e8 e3 c8 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104cfd:	89 1c 24             	mov    %ebx,(%esp)
80104d00:	e8 fb cb ff ff       	call   80101900 <iunlockput>
  end_op();
80104d05:	e8 66 de ff ff       	call   80102b70 <end_op>
}
80104d0a:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104d0d:	31 c0                	xor    %eax,%eax
}
80104d0f:	5b                   	pop    %ebx
80104d10:	5e                   	pop    %esi
80104d11:	5f                   	pop    %edi
80104d12:	5d                   	pop    %ebp
80104d13:	c3                   	ret    
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104d18:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104d1c:	0f 86 79 ff ff ff    	jbe    80104c9b <sys_unlink+0xbb>
80104d22:	bf 20 00 00 00       	mov    $0x20,%edi
80104d27:	eb 15                	jmp    80104d3e <sys_unlink+0x15e>
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d30:	8d 57 10             	lea    0x10(%edi),%edx
80104d33:	3b 53 58             	cmp    0x58(%ebx),%edx
80104d36:	0f 83 5f ff ff ff    	jae    80104c9b <sys_unlink+0xbb>
80104d3c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d3e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d45:	00 
80104d46:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104d4a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d4e:	89 1c 24             	mov    %ebx,(%esp)
80104d51:	e8 fa cb ff ff       	call   80101950 <readi>
80104d56:	83 f8 10             	cmp    $0x10,%eax
80104d59:	75 42                	jne    80104d9d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104d5b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d60:	74 ce                	je     80104d30 <sys_unlink+0x150>
    iunlockput(ip);
80104d62:	89 1c 24             	mov    %ebx,(%esp)
80104d65:	e8 96 cb ff ff       	call   80101900 <iunlockput>
  iunlockput(dp);
80104d6a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d6d:	89 04 24             	mov    %eax,(%esp)
80104d70:	e8 8b cb ff ff       	call   80101900 <iunlockput>
  end_op();
80104d75:	e8 f6 dd ff ff       	call   80102b70 <end_op>
}
80104d7a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104d7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d82:	5b                   	pop    %ebx
80104d83:	5e                   	pop    %esi
80104d84:	5f                   	pop    %edi
80104d85:	5d                   	pop    %ebp
80104d86:	c3                   	ret    
80104d87:	90                   	nop
    dp->nlink--;
80104d88:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d8b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104d90:	89 04 24             	mov    %eax,(%esp)
80104d93:	e8 48 c8 ff ff       	call   801015e0 <iupdate>
80104d98:	e9 48 ff ff ff       	jmp    80104ce5 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104d9d:	c7 04 24 a0 75 10 80 	movl   $0x801075a0,(%esp)
80104da4:	e8 b7 b5 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104da9:	c7 04 24 b2 75 10 80 	movl   $0x801075b2,(%esp)
80104db0:	e8 ab b5 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104db5:	c7 04 24 8e 75 10 80 	movl   $0x8010758e,(%esp)
80104dbc:	e8 9f b5 ff ff       	call   80100360 <panic>
80104dc1:	eb 0d                	jmp    80104dd0 <sys_open>
80104dc3:	90                   	nop
80104dc4:	90                   	nop
80104dc5:	90                   	nop
80104dc6:	90                   	nop
80104dc7:	90                   	nop
80104dc8:	90                   	nop
80104dc9:	90                   	nop
80104dca:	90                   	nop
80104dcb:	90                   	nop
80104dcc:	90                   	nop
80104dcd:	90                   	nop
80104dce:	90                   	nop
80104dcf:	90                   	nop

80104dd0 <sys_open>:

int
sys_open(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
80104dd6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104dd9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104de0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104de7:	e8 44 f8 ff ff       	call   80104630 <argstr>
80104dec:	85 c0                	test   %eax,%eax
80104dee:	0f 88 d1 00 00 00    	js     80104ec5 <sys_open+0xf5>
80104df4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104df7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dfb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e02:	e8 99 f7 ff ff       	call   801045a0 <argint>
80104e07:	85 c0                	test   %eax,%eax
80104e09:	0f 88 b6 00 00 00    	js     80104ec5 <sys_open+0xf5>
    return -1;

  begin_op();
80104e0f:	e8 ec dc ff ff       	call   80102b00 <begin_op>

  if(omode & O_CREATE){
80104e14:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104e18:	0f 85 82 00 00 00    	jne    80104ea0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104e1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e21:	89 04 24             	mov    %eax,(%esp)
80104e24:	e8 c7 d0 ff ff       	call   80101ef0 <namei>
80104e29:	85 c0                	test   %eax,%eax
80104e2b:	89 c6                	mov    %eax,%esi
80104e2d:	0f 84 8d 00 00 00    	je     80104ec0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104e33:	89 04 24             	mov    %eax,(%esp)
80104e36:	e8 65 c8 ff ff       	call   801016a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e3b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e40:	0f 84 92 00 00 00    	je     80104ed8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104e46:	e8 05 bf ff ff       	call   80100d50 <filealloc>
80104e4b:	85 c0                	test   %eax,%eax
80104e4d:	89 c3                	mov    %eax,%ebx
80104e4f:	0f 84 93 00 00 00    	je     80104ee8 <sys_open+0x118>
80104e55:	e8 86 f8 ff ff       	call   801046e0 <fdalloc>
80104e5a:	85 c0                	test   %eax,%eax
80104e5c:	89 c7                	mov    %eax,%edi
80104e5e:	0f 88 94 00 00 00    	js     80104ef8 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104e64:	89 34 24             	mov    %esi,(%esp)
80104e67:	e8 14 c9 ff ff       	call   80101780 <iunlock>
  end_op();
80104e6c:	e8 ff dc ff ff       	call   80102b70 <end_op>

  f->type = FD_INODE;
80104e71:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104e7a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104e7d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e84:	89 c2                	mov    %eax,%edx
80104e86:	83 e2 01             	and    $0x1,%edx
80104e89:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e8c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104e8e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104e91:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e93:	0f 95 43 09          	setne  0x9(%ebx)
}
80104e97:	83 c4 2c             	add    $0x2c,%esp
80104e9a:	5b                   	pop    %ebx
80104e9b:	5e                   	pop    %esi
80104e9c:	5f                   	pop    %edi
80104e9d:	5d                   	pop    %ebp
80104e9e:	c3                   	ret    
80104e9f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104ea0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ea3:	31 c9                	xor    %ecx,%ecx
80104ea5:	ba 02 00 00 00       	mov    $0x2,%edx
80104eaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104eb1:	e8 6a f8 ff ff       	call   80104720 <create>
    if(ip == 0){
80104eb6:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104eb8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104eba:	75 8a                	jne    80104e46 <sys_open+0x76>
80104ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104ec0:	e8 ab dc ff ff       	call   80102b70 <end_op>
}
80104ec5:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ecd:	5b                   	pop    %ebx
80104ece:	5e                   	pop    %esi
80104ecf:	5f                   	pop    %edi
80104ed0:	5d                   	pop    %ebp
80104ed1:	c3                   	ret    
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104edb:	85 c0                	test   %eax,%eax
80104edd:	0f 84 63 ff ff ff    	je     80104e46 <sys_open+0x76>
80104ee3:	90                   	nop
80104ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104ee8:	89 34 24             	mov    %esi,(%esp)
80104eeb:	e8 10 ca ff ff       	call   80101900 <iunlockput>
80104ef0:	eb ce                	jmp    80104ec0 <sys_open+0xf0>
80104ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104ef8:	89 1c 24             	mov    %ebx,(%esp)
80104efb:	e8 10 bf ff ff       	call   80100e10 <fileclose>
80104f00:	eb e6                	jmp    80104ee8 <sys_open+0x118>
80104f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f10 <sys_mkdir>:

int
sys_mkdir(void)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104f16:	e8 e5 db ff ff       	call   80102b00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104f1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f29:	e8 02 f7 ff ff       	call   80104630 <argstr>
80104f2e:	85 c0                	test   %eax,%eax
80104f30:	78 2e                	js     80104f60 <sys_mkdir+0x50>
80104f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f35:	31 c9                	xor    %ecx,%ecx
80104f37:	ba 01 00 00 00       	mov    $0x1,%edx
80104f3c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f43:	e8 d8 f7 ff ff       	call   80104720 <create>
80104f48:	85 c0                	test   %eax,%eax
80104f4a:	74 14                	je     80104f60 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f4c:	89 04 24             	mov    %eax,(%esp)
80104f4f:	e8 ac c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104f54:	e8 17 dc ff ff       	call   80102b70 <end_op>
  return 0;
80104f59:	31 c0                	xor    %eax,%eax
}
80104f5b:	c9                   	leave  
80104f5c:	c3                   	ret    
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f60:	e8 0b dc ff ff       	call   80102b70 <end_op>
    return -1;
80104f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f6a:	c9                   	leave  
80104f6b:	c3                   	ret    
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f70 <sys_mknod>:

int
sys_mknod(void)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104f76:	e8 85 db ff ff       	call   80102b00 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104f7b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f89:	e8 a2 f6 ff ff       	call   80104630 <argstr>
80104f8e:	85 c0                	test   %eax,%eax
80104f90:	78 5e                	js     80104ff0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104f92:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f95:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104fa0:	e8 fb f5 ff ff       	call   801045a0 <argint>
  if((argstr(0, &path)) < 0 ||
80104fa5:	85 c0                	test   %eax,%eax
80104fa7:	78 47                	js     80104ff0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104fa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fb0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104fb7:	e8 e4 f5 ff ff       	call   801045a0 <argint>
     argint(1, &major) < 0 ||
80104fbc:	85 c0                	test   %eax,%eax
80104fbe:	78 30                	js     80104ff0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104fc0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80104fc4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104fc9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104fcd:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fd3:	e8 48 f7 ff ff       	call   80104720 <create>
80104fd8:	85 c0                	test   %eax,%eax
80104fda:	74 14                	je     80104ff0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104fdc:	89 04 24             	mov    %eax,(%esp)
80104fdf:	e8 1c c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104fe4:	e8 87 db ff ff       	call   80102b70 <end_op>
  return 0;
80104fe9:	31 c0                	xor    %eax,%eax
}
80104feb:	c9                   	leave  
80104fec:	c3                   	ret    
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104ff0:	e8 7b db ff ff       	call   80102b70 <end_op>
    return -1;
80104ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ffa:	c9                   	leave  
80104ffb:	c3                   	ret    
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105000 <sys_chdir>:

int
sys_chdir(void)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
80105005:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105008:	e8 83 e6 ff ff       	call   80103690 <myproc>
8010500d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010500f:	e8 ec da ff ff       	call   80102b00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105014:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105017:	89 44 24 04          	mov    %eax,0x4(%esp)
8010501b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105022:	e8 09 f6 ff ff       	call   80104630 <argstr>
80105027:	85 c0                	test   %eax,%eax
80105029:	78 4a                	js     80105075 <sys_chdir+0x75>
8010502b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010502e:	89 04 24             	mov    %eax,(%esp)
80105031:	e8 ba ce ff ff       	call   80101ef0 <namei>
80105036:	85 c0                	test   %eax,%eax
80105038:	89 c3                	mov    %eax,%ebx
8010503a:	74 39                	je     80105075 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010503c:	89 04 24             	mov    %eax,(%esp)
8010503f:	e8 5c c6 ff ff       	call   801016a0 <ilock>
  if(ip->type != T_DIR){
80105044:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105049:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010504c:	75 22                	jne    80105070 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010504e:	e8 2d c7 ff ff       	call   80101780 <iunlock>
  iput(curproc->cwd);
80105053:	8b 46 70             	mov    0x70(%esi),%eax
80105056:	89 04 24             	mov    %eax,(%esp)
80105059:	e8 62 c7 ff ff       	call   801017c0 <iput>
  end_op();
8010505e:	e8 0d db ff ff       	call   80102b70 <end_op>
  curproc->cwd = ip;
  return 0;
80105063:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105065:	89 5e 70             	mov    %ebx,0x70(%esi)
}
80105068:	83 c4 20             	add    $0x20,%esp
8010506b:	5b                   	pop    %ebx
8010506c:	5e                   	pop    %esi
8010506d:	5d                   	pop    %ebp
8010506e:	c3                   	ret    
8010506f:	90                   	nop
    iunlockput(ip);
80105070:	e8 8b c8 ff ff       	call   80101900 <iunlockput>
    end_op();
80105075:	e8 f6 da ff ff       	call   80102b70 <end_op>
}
8010507a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010507d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105082:	5b                   	pop    %ebx
80105083:	5e                   	pop    %esi
80105084:	5d                   	pop    %ebp
80105085:	c3                   	ret    
80105086:	8d 76 00             	lea    0x0(%esi),%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105090 <sys_exec>:

int
sys_exec(void)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
80105095:	53                   	push   %ebx
80105096:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010509c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801050a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801050a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050ad:	e8 7e f5 ff ff       	call   80104630 <argstr>
801050b2:	85 c0                	test   %eax,%eax
801050b4:	0f 88 84 00 00 00    	js     8010513e <sys_exec+0xae>
801050ba:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801050c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801050c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050cb:	e8 d0 f4 ff ff       	call   801045a0 <argint>
801050d0:	85 c0                	test   %eax,%eax
801050d2:	78 6a                	js     8010513e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801050d4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801050da:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801050dc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801050e3:	00 
801050e4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801050ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801050f1:	00 
801050f2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801050f8:	89 04 24             	mov    %eax,(%esp)
801050fb:	e8 b0 f1 ff ff       	call   801042b0 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105100:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105106:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010510a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010510d:	89 04 24             	mov    %eax,(%esp)
80105110:	e8 eb f3 ff ff       	call   80104500 <fetchint>
80105115:	85 c0                	test   %eax,%eax
80105117:	78 25                	js     8010513e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105119:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010511f:	85 c0                	test   %eax,%eax
80105121:	74 2d                	je     80105150 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105123:	89 74 24 04          	mov    %esi,0x4(%esp)
80105127:	89 04 24             	mov    %eax,(%esp)
8010512a:	e8 11 f4 ff ff       	call   80104540 <fetchstr>
8010512f:	85 c0                	test   %eax,%eax
80105131:	78 0b                	js     8010513e <sys_exec+0xae>
  for(i=0;; i++){
80105133:	83 c3 01             	add    $0x1,%ebx
80105136:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105139:	83 fb 20             	cmp    $0x20,%ebx
8010513c:	75 c2                	jne    80105100 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
8010513e:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
80105144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105149:	5b                   	pop    %ebx
8010514a:	5e                   	pop    %esi
8010514b:	5f                   	pop    %edi
8010514c:	5d                   	pop    %ebp
8010514d:	c3                   	ret    
8010514e:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105150:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105156:	89 44 24 04          	mov    %eax,0x4(%esp)
8010515a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105160:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105167:	00 00 00 00 
  return exec(path, argv);
8010516b:	89 04 24             	mov    %eax,(%esp)
8010516e:	e8 2d b8 ff ff       	call   801009a0 <exec>
}
80105173:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5f                   	pop    %edi
8010517c:	5d                   	pop    %ebp
8010517d:	c3                   	ret    
8010517e:	66 90                	xchg   %ax,%ax

80105180 <sys_pipe>:

int
sys_pipe(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	53                   	push   %ebx
80105184:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105187:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010518a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105191:	00 
80105192:	89 44 24 04          	mov    %eax,0x4(%esp)
80105196:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010519d:	e8 2e f4 ff ff       	call   801045d0 <argptr>
801051a2:	85 c0                	test   %eax,%eax
801051a4:	78 6d                	js     80105213 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801051a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051b0:	89 04 24             	mov    %eax,(%esp)
801051b3:	e8 a8 df ff ff       	call   80103160 <pipealloc>
801051b8:	85 c0                	test   %eax,%eax
801051ba:	78 57                	js     80105213 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801051bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051bf:	e8 1c f5 ff ff       	call   801046e0 <fdalloc>
801051c4:	85 c0                	test   %eax,%eax
801051c6:	89 c3                	mov    %eax,%ebx
801051c8:	78 33                	js     801051fd <sys_pipe+0x7d>
801051ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051cd:	e8 0e f5 ff ff       	call   801046e0 <fdalloc>
801051d2:	85 c0                	test   %eax,%eax
801051d4:	78 1a                	js     801051f0 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801051d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051d9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801051db:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051de:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801051e1:	83 c4 24             	add    $0x24,%esp
  return 0;
801051e4:	31 c0                	xor    %eax,%eax
}
801051e6:	5b                   	pop    %ebx
801051e7:	5d                   	pop    %ebp
801051e8:	c3                   	ret    
801051e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801051f0:	e8 9b e4 ff ff       	call   80103690 <myproc>
801051f5:	c7 44 98 30 00 00 00 	movl   $0x0,0x30(%eax,%ebx,4)
801051fc:	00 
    fileclose(rf);
801051fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105200:	89 04 24             	mov    %eax,(%esp)
80105203:	e8 08 bc ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
80105208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010520b:	89 04 24             	mov    %eax,(%esp)
8010520e:	e8 fd bb ff ff       	call   80100e10 <fileclose>
}
80105213:	83 c4 24             	add    $0x24,%esp
    return -1;
80105216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010521b:	5b                   	pop    %ebx
8010521c:	5d                   	pop    %ebp
8010521d:	c3                   	ret    
8010521e:	66 90                	xchg   %ax,%ax

80105220 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
80105226:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105229:	89 44 24 04          	mov    %eax,0x4(%esp)
8010522d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105234:	e8 67 f3 ff ff       	call   801045a0 <argint>
80105239:	85 c0                	test   %eax,%eax
8010523b:	78 33                	js     80105270 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
8010523d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105240:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105247:	00 
80105248:	89 44 24 04          	mov    %eax,0x4(%esp)
8010524c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105253:	e8 78 f3 ff ff       	call   801045d0 <argptr>
80105258:	85 c0                	test   %eax,%eax
8010525a:	78 14                	js     80105270 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
8010525c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010525f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105263:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105266:	89 04 24             	mov    %eax,(%esp)
80105269:	e8 82 1b 00 00       	call   80106df0 <shm_open>
}
8010526e:	c9                   	leave  
8010526f:	c3                   	ret    
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <sys_shm_close>:

int sys_shm_close(void) {
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105286:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105289:	89 44 24 04          	mov    %eax,0x4(%esp)
8010528d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105294:	e8 07 f3 ff ff       	call   801045a0 <argint>
80105299:	85 c0                	test   %eax,%eax
8010529b:	78 13                	js     801052b0 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
8010529d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a0:	89 04 24             	mov    %eax,(%esp)
801052a3:	e8 58 1b 00 00       	call   80106e00 <shm_close>
}
801052a8:	c9                   	leave  
801052a9:	c3                   	ret    
801052aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052b5:	c9                   	leave  
801052b6:	c3                   	ret    
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <sys_fork>:

int
sys_fork(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801052c3:	5d                   	pop    %ebp
  return fork();
801052c4:	e9 77 e5 ff ff       	jmp    80103840 <fork>
801052c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052d0 <sys_exit>:

int
sys_exit(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801052d6:	e8 c5 e7 ff ff       	call   80103aa0 <exit>
  return 0;  // not reached
}
801052db:	31 c0                	xor    %eax,%eax
801052dd:	c9                   	leave  
801052de:	c3                   	ret    
801052df:	90                   	nop

801052e0 <sys_wait>:

int
sys_wait(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801052e3:	5d                   	pop    %ebp
  return wait();
801052e4:	e9 d7 e9 ff ff       	jmp    80103cc0 <wait>
801052e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052f0 <sys_kill>:

int
sys_kill(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801052f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105304:	e8 97 f2 ff ff       	call   801045a0 <argint>
80105309:	85 c0                	test   %eax,%eax
8010530b:	78 13                	js     80105320 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010530d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105310:	89 04 24             	mov    %eax,(%esp)
80105313:	e8 08 eb ff ff       	call   80103e20 <kill>
}
80105318:	c9                   	leave  
80105319:	c3                   	ret    
8010531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <sys_getpid>:

int
sys_getpid(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105336:	e8 55 e3 ff ff       	call   80103690 <myproc>
8010533b:	8b 40 18             	mov    0x18(%eax),%eax
}
8010533e:	c9                   	leave  
8010533f:	c3                   	ret    

80105340 <sys_sbrk>:

int
sys_sbrk(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	53                   	push   %ebx
80105344:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105347:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010534a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010534e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105355:	e8 46 f2 ff ff       	call   801045a0 <argint>
8010535a:	85 c0                	test   %eax,%eax
8010535c:	78 22                	js     80105380 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010535e:	e8 2d e3 ff ff       	call   80103690 <myproc>
  if(growproc(n) < 0)
80105363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
80105366:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105368:	89 14 24             	mov    %edx,(%esp)
8010536b:	e8 60 e4 ff ff       	call   801037d0 <growproc>
80105370:	85 c0                	test   %eax,%eax
80105372:	78 0c                	js     80105380 <sys_sbrk+0x40>
    return -1;
  return addr;
80105374:	89 d8                	mov    %ebx,%eax
}
80105376:	83 c4 24             	add    $0x24,%esp
80105379:	5b                   	pop    %ebx
8010537a:	5d                   	pop    %ebp
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105385:	eb ef                	jmp    80105376 <sys_sbrk+0x36>
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <sys_sleep>:

int
sys_sleep(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	53                   	push   %ebx
80105394:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105397:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010539e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053a5:	e8 f6 f1 ff ff       	call   801045a0 <argint>
801053aa:	85 c0                	test   %eax,%eax
801053ac:	78 7e                	js     8010542c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801053ae:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
801053b5:	e8 b6 ed ff ff       	call   80104170 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801053ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801053bd:	8b 1d a0 56 11 80    	mov    0x801156a0,%ebx
  while(ticks - ticks0 < n){
801053c3:	85 d2                	test   %edx,%edx
801053c5:	75 29                	jne    801053f0 <sys_sleep+0x60>
801053c7:	eb 4f                	jmp    80105418 <sys_sleep+0x88>
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801053d0:	c7 44 24 04 60 4e 11 	movl   $0x80114e60,0x4(%esp)
801053d7:	80 
801053d8:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
801053df:	e8 2c e8 ff ff       	call   80103c10 <sleep>
  while(ticks - ticks0 < n){
801053e4:	a1 a0 56 11 80       	mov    0x801156a0,%eax
801053e9:	29 d8                	sub    %ebx,%eax
801053eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801053ee:	73 28                	jae    80105418 <sys_sleep+0x88>
    if(myproc()->killed){
801053f0:	e8 9b e2 ff ff       	call   80103690 <myproc>
801053f5:	8b 40 2c             	mov    0x2c(%eax),%eax
801053f8:	85 c0                	test   %eax,%eax
801053fa:	74 d4                	je     801053d0 <sys_sleep+0x40>
      release(&tickslock);
801053fc:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
80105403:	e8 58 ee ff ff       	call   80104260 <release>
      return -1;
80105408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010540d:	83 c4 24             	add    $0x24,%esp
80105410:	5b                   	pop    %ebx
80105411:	5d                   	pop    %ebp
80105412:	c3                   	ret    
80105413:	90                   	nop
80105414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105418:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
8010541f:	e8 3c ee ff ff       	call   80104260 <release>
}
80105424:	83 c4 24             	add    $0x24,%esp
  return 0;
80105427:	31 c0                	xor    %eax,%eax
}
80105429:	5b                   	pop    %ebx
8010542a:	5d                   	pop    %ebp
8010542b:	c3                   	ret    
    return -1;
8010542c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105431:	eb da                	jmp    8010540d <sys_sleep+0x7d>
80105433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	53                   	push   %ebx
80105444:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105447:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
8010544e:	e8 1d ed ff ff       	call   80104170 <acquire>
  xticks = ticks;
80105453:	8b 1d a0 56 11 80    	mov    0x801156a0,%ebx
  release(&tickslock);
80105459:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
80105460:	e8 fb ed ff ff       	call   80104260 <release>
  return xticks;
}
80105465:	83 c4 14             	add    $0x14,%esp
80105468:	89 d8                	mov    %ebx,%eax
8010546a:	5b                   	pop    %ebx
8010546b:	5d                   	pop    %ebp
8010546c:	c3                   	ret    

8010546d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010546d:	1e                   	push   %ds
  pushl %es
8010546e:	06                   	push   %es
  pushl %fs
8010546f:	0f a0                	push   %fs
  pushl %gs
80105471:	0f a8                	push   %gs
  pushal
80105473:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105474:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105478:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010547a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010547c:	54                   	push   %esp
  call trap
8010547d:	e8 de 00 00 00       	call   80105560 <trap>
  addl $4, %esp
80105482:	83 c4 04             	add    $0x4,%esp

80105485 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105485:	61                   	popa   
  popl %gs
80105486:	0f a9                	pop    %gs
  popl %fs
80105488:	0f a1                	pop    %fs
  popl %es
8010548a:	07                   	pop    %es
  popl %ds
8010548b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010548c:	83 c4 08             	add    $0x8,%esp
  iret
8010548f:	cf                   	iret   

80105490 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105490:	31 c0                	xor    %eax,%eax
80105492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105498:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010549f:	b9 08 00 00 00       	mov    $0x8,%ecx
801054a4:	66 89 0c c5 a2 4e 11 	mov    %cx,-0x7feeb15e(,%eax,8)
801054ab:	80 
801054ac:	c6 04 c5 a4 4e 11 80 	movb   $0x0,-0x7feeb15c(,%eax,8)
801054b3:	00 
801054b4:	c6 04 c5 a5 4e 11 80 	movb   $0x8e,-0x7feeb15b(,%eax,8)
801054bb:	8e 
801054bc:	66 89 14 c5 a0 4e 11 	mov    %dx,-0x7feeb160(,%eax,8)
801054c3:	80 
801054c4:	c1 ea 10             	shr    $0x10,%edx
801054c7:	66 89 14 c5 a6 4e 11 	mov    %dx,-0x7feeb15a(,%eax,8)
801054ce:	80 
  for(i = 0; i < 256; i++)
801054cf:	83 c0 01             	add    $0x1,%eax
801054d2:	3d 00 01 00 00       	cmp    $0x100,%eax
801054d7:	75 bf                	jne    80105498 <tvinit+0x8>
{
801054d9:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054da:	ba 08 00 00 00       	mov    $0x8,%edx
{
801054df:	89 e5                	mov    %esp,%ebp
801054e1:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054e4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801054e9:	c7 44 24 04 c1 75 10 	movl   $0x801075c1,0x4(%esp)
801054f0:	80 
801054f1:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054f8:	66 89 15 a2 50 11 80 	mov    %dx,0x801150a2
801054ff:	66 a3 a0 50 11 80    	mov    %ax,0x801150a0
80105505:	c1 e8 10             	shr    $0x10,%eax
80105508:	c6 05 a4 50 11 80 00 	movb   $0x0,0x801150a4
8010550f:	c6 05 a5 50 11 80 ef 	movb   $0xef,0x801150a5
80105516:	66 a3 a6 50 11 80    	mov    %ax,0x801150a6
  initlock(&tickslock, "time");
8010551c:	e8 5f eb ff ff       	call   80104080 <initlock>
}
80105521:	c9                   	leave  
80105522:	c3                   	ret    
80105523:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <idtinit>:

void
idtinit(void)
{
80105530:	55                   	push   %ebp
  pd[0] = size-1;
80105531:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105536:	89 e5                	mov    %esp,%ebp
80105538:	83 ec 10             	sub    $0x10,%esp
8010553b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010553f:	b8 a0 4e 11 80       	mov    $0x80114ea0,%eax
80105544:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105548:	c1 e8 10             	shr    $0x10,%eax
8010554b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010554f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105552:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	57                   	push   %edi
80105564:	56                   	push   %esi
80105565:	53                   	push   %ebx
80105566:	83 ec 3c             	sub    $0x3c,%esp
80105569:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010556c:	8b 43 30             	mov    0x30(%ebx),%eax
8010556f:	83 f8 40             	cmp    $0x40,%eax
80105572:	0f 84 a0 01 00 00    	je     80105718 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105578:	83 e8 20             	sub    $0x20,%eax
8010557b:	83 f8 1f             	cmp    $0x1f,%eax
8010557e:	77 08                	ja     80105588 <trap+0x28>
80105580:	ff 24 85 68 76 10 80 	jmp    *-0x7fef8998(,%eax,4)
80105587:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105588:	e8 03 e1 ff ff       	call   80103690 <myproc>
8010558d:	85 c0                	test   %eax,%eax
8010558f:	90                   	nop
80105590:	0f 84 fa 01 00 00    	je     80105790 <trap+0x230>
80105596:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010559a:	0f 84 f0 01 00 00    	je     80105790 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801055a0:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055a3:	8b 53 38             	mov    0x38(%ebx),%edx
801055a6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801055a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
801055ac:	e8 bf e0 ff ff       	call   80103670 <cpuid>
801055b1:	8b 73 30             	mov    0x30(%ebx),%esi
801055b4:	89 c7                	mov    %eax,%edi
801055b6:	8b 43 34             	mov    0x34(%ebx),%eax
801055b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801055bc:	e8 cf e0 ff ff       	call   80103690 <myproc>
801055c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801055c4:	e8 c7 e0 ff ff       	call   80103690 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801055cc:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801055d0:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055d3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801055d6:	89 7c 24 14          	mov    %edi,0x14(%esp)
801055da:	89 54 24 18          	mov    %edx,0x18(%esp)
801055de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
801055e1:	83 c6 74             	add    $0x74,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055e4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801055e8:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055ec:	89 54 24 10          	mov    %edx,0x10(%esp)
801055f0:	8b 40 18             	mov    0x18(%eax),%eax
801055f3:	c7 04 24 24 76 10 80 	movl   $0x80107624,(%esp)
801055fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801055fe:	e8 4d b0 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105603:	e8 88 e0 ff ff       	call   80103690 <myproc>
80105608:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
8010560f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105610:	e8 7b e0 ff ff       	call   80103690 <myproc>
80105615:	85 c0                	test   %eax,%eax
80105617:	74 0c                	je     80105625 <trap+0xc5>
80105619:	e8 72 e0 ff ff       	call   80103690 <myproc>
8010561e:	8b 50 2c             	mov    0x2c(%eax),%edx
80105621:	85 d2                	test   %edx,%edx
80105623:	75 4b                	jne    80105670 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105625:	e8 66 e0 ff ff       	call   80103690 <myproc>
8010562a:	85 c0                	test   %eax,%eax
8010562c:	74 0d                	je     8010563b <trap+0xdb>
8010562e:	66 90                	xchg   %ax,%ax
80105630:	e8 5b e0 ff ff       	call   80103690 <myproc>
80105635:	83 78 14 04          	cmpl   $0x4,0x14(%eax)
80105639:	74 4d                	je     80105688 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010563b:	e8 50 e0 ff ff       	call   80103690 <myproc>
80105640:	85 c0                	test   %eax,%eax
80105642:	74 1d                	je     80105661 <trap+0x101>
80105644:	e8 47 e0 ff ff       	call   80103690 <myproc>
80105649:	8b 40 2c             	mov    0x2c(%eax),%eax
8010564c:	85 c0                	test   %eax,%eax
8010564e:	74 11                	je     80105661 <trap+0x101>
80105650:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105654:	83 e0 03             	and    $0x3,%eax
80105657:	66 83 f8 03          	cmp    $0x3,%ax
8010565b:	0f 84 e8 00 00 00    	je     80105749 <trap+0x1e9>
    exit();
}
80105661:	83 c4 3c             	add    $0x3c,%esp
80105664:	5b                   	pop    %ebx
80105665:	5e                   	pop    %esi
80105666:	5f                   	pop    %edi
80105667:	5d                   	pop    %ebp
80105668:	c3                   	ret    
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105670:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105674:	83 e0 03             	and    $0x3,%eax
80105677:	66 83 f8 03          	cmp    $0x3,%ax
8010567b:	75 a8                	jne    80105625 <trap+0xc5>
    exit();
8010567d:	e8 1e e4 ff ff       	call   80103aa0 <exit>
80105682:	eb a1                	jmp    80105625 <trap+0xc5>
80105684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105688:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105690:	75 a9                	jne    8010563b <trap+0xdb>
    yield();
80105692:	e8 39 e5 ff ff       	call   80103bd0 <yield>
80105697:	eb a2                	jmp    8010563b <trap+0xdb>
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801056a0:	e8 cb df ff ff       	call   80103670 <cpuid>
801056a5:	85 c0                	test   %eax,%eax
801056a7:	0f 84 b3 00 00 00    	je     80105760 <trap+0x200>
801056ad:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
801056b0:	e8 bb d0 ff ff       	call   80102770 <lapiceoi>
    break;
801056b5:	e9 56 ff ff ff       	jmp    80105610 <trap+0xb0>
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
801056c0:	e8 fb ce ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
801056c5:	e8 a6 d0 ff ff       	call   80102770 <lapiceoi>
    break;
801056ca:	e9 41 ff ff ff       	jmp    80105610 <trap+0xb0>
801056cf:	90                   	nop
    uartintr();
801056d0:	e8 1b 02 00 00       	call   801058f0 <uartintr>
    lapiceoi();
801056d5:	e8 96 d0 ff ff       	call   80102770 <lapiceoi>
    break;
801056da:	e9 31 ff ff ff       	jmp    80105610 <trap+0xb0>
801056df:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801056e0:	8b 7b 38             	mov    0x38(%ebx),%edi
801056e3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801056e7:	e8 84 df ff ff       	call   80103670 <cpuid>
801056ec:	c7 04 24 cc 75 10 80 	movl   $0x801075cc,(%esp)
801056f3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801056f7:	89 74 24 08          	mov    %esi,0x8(%esp)
801056fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ff:	e8 4c af ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105704:	e8 67 d0 ff ff       	call   80102770 <lapiceoi>
    break;
80105709:	e9 02 ff ff ff       	jmp    80105610 <trap+0xb0>
8010570e:	66 90                	xchg   %ax,%ax
    ideintr();
80105710:	e8 5b c9 ff ff       	call   80102070 <ideintr>
80105715:	eb 96                	jmp    801056ad <trap+0x14d>
80105717:	90                   	nop
80105718:	90                   	nop
80105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105720:	e8 6b df ff ff       	call   80103690 <myproc>
80105725:	8b 70 2c             	mov    0x2c(%eax),%esi
80105728:	85 f6                	test   %esi,%esi
8010572a:	75 2c                	jne    80105758 <trap+0x1f8>
    myproc()->tf = tf;
8010572c:	e8 5f df ff ff       	call   80103690 <myproc>
80105731:	89 58 20             	mov    %ebx,0x20(%eax)
    syscall();
80105734:	e8 37 ef ff ff       	call   80104670 <syscall>
    if(myproc()->killed)
80105739:	e8 52 df ff ff       	call   80103690 <myproc>
8010573e:	8b 48 2c             	mov    0x2c(%eax),%ecx
80105741:	85 c9                	test   %ecx,%ecx
80105743:	0f 84 18 ff ff ff    	je     80105661 <trap+0x101>
}
80105749:	83 c4 3c             	add    $0x3c,%esp
8010574c:	5b                   	pop    %ebx
8010574d:	5e                   	pop    %esi
8010574e:	5f                   	pop    %edi
8010574f:	5d                   	pop    %ebp
      exit();
80105750:	e9 4b e3 ff ff       	jmp    80103aa0 <exit>
80105755:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105758:	e8 43 e3 ff ff       	call   80103aa0 <exit>
8010575d:	eb cd                	jmp    8010572c <trap+0x1cc>
8010575f:	90                   	nop
      acquire(&tickslock);
80105760:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
80105767:	e8 04 ea ff ff       	call   80104170 <acquire>
      wakeup(&ticks);
8010576c:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
      ticks++;
80105773:	83 05 a0 56 11 80 01 	addl   $0x1,0x801156a0
      wakeup(&ticks);
8010577a:	e8 31 e6 ff ff       	call   80103db0 <wakeup>
      release(&tickslock);
8010577f:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
80105786:	e8 d5 ea ff ff       	call   80104260 <release>
8010578b:	e9 1d ff ff ff       	jmp    801056ad <trap+0x14d>
80105790:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105793:	8b 73 38             	mov    0x38(%ebx),%esi
80105796:	e8 d5 de ff ff       	call   80103670 <cpuid>
8010579b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010579f:	89 74 24 0c          	mov    %esi,0xc(%esp)
801057a3:	89 44 24 08          	mov    %eax,0x8(%esp)
801057a7:	8b 43 30             	mov    0x30(%ebx),%eax
801057aa:	c7 04 24 f0 75 10 80 	movl   $0x801075f0,(%esp)
801057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801057b5:	e8 96 ae ff ff       	call   80100650 <cprintf>
      panic("trap");
801057ba:	c7 04 24 c6 75 10 80 	movl   $0x801075c6,(%esp)
801057c1:	e8 9a ab ff ff       	call   80100360 <panic>
801057c6:	66 90                	xchg   %ax,%ax
801057c8:	66 90                	xchg   %ax,%ax
801057ca:	66 90                	xchg   %ax,%ax
801057cc:	66 90                	xchg   %ax,%ax
801057ce:	66 90                	xchg   %ax,%ax

801057d0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801057d0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
801057d5:	55                   	push   %ebp
801057d6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801057d8:	85 c0                	test   %eax,%eax
801057da:	74 14                	je     801057f0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801057dc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801057e1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801057e2:	a8 01                	test   $0x1,%al
801057e4:	74 0a                	je     801057f0 <uartgetc+0x20>
801057e6:	b2 f8                	mov    $0xf8,%dl
801057e8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801057e9:	0f b6 c0             	movzbl %al,%eax
}
801057ec:	5d                   	pop    %ebp
801057ed:	c3                   	ret    
801057ee:	66 90                	xchg   %ax,%ax
    return -1;
801057f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f5:	5d                   	pop    %ebp
801057f6:	c3                   	ret    
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105800 <uartputc>:
  if(!uart)
80105800:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105805:	85 c0                	test   %eax,%eax
80105807:	74 3f                	je     80105848 <uartputc+0x48>
{
80105809:	55                   	push   %ebp
8010580a:	89 e5                	mov    %esp,%ebp
8010580c:	56                   	push   %esi
8010580d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105812:	53                   	push   %ebx
  if(!uart)
80105813:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105818:	83 ec 10             	sub    $0x10,%esp
8010581b:	eb 14                	jmp    80105831 <uartputc+0x31>
8010581d:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105820:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105827:	e8 64 cf ff ff       	call   80102790 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010582c:	83 eb 01             	sub    $0x1,%ebx
8010582f:	74 07                	je     80105838 <uartputc+0x38>
80105831:	89 f2                	mov    %esi,%edx
80105833:	ec                   	in     (%dx),%al
80105834:	a8 20                	test   $0x20,%al
80105836:	74 e8                	je     80105820 <uartputc+0x20>
  outb(COM1+0, c);
80105838:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010583c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105841:	ee                   	out    %al,(%dx)
}
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	5b                   	pop    %ebx
80105846:	5e                   	pop    %esi
80105847:	5d                   	pop    %ebp
80105848:	f3 c3                	repz ret 
8010584a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105850 <uartinit>:
{
80105850:	55                   	push   %ebp
80105851:	31 c9                	xor    %ecx,%ecx
80105853:	89 e5                	mov    %esp,%ebp
80105855:	89 c8                	mov    %ecx,%eax
80105857:	57                   	push   %edi
80105858:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010585d:	56                   	push   %esi
8010585e:	89 fa                	mov    %edi,%edx
80105860:	53                   	push   %ebx
80105861:	83 ec 1c             	sub    $0x1c,%esp
80105864:	ee                   	out    %al,(%dx)
80105865:	be fb 03 00 00       	mov    $0x3fb,%esi
8010586a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010586f:	89 f2                	mov    %esi,%edx
80105871:	ee                   	out    %al,(%dx)
80105872:	b8 0c 00 00 00       	mov    $0xc,%eax
80105877:	b2 f8                	mov    $0xf8,%dl
80105879:	ee                   	out    %al,(%dx)
8010587a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010587f:	89 c8                	mov    %ecx,%eax
80105881:	89 da                	mov    %ebx,%edx
80105883:	ee                   	out    %al,(%dx)
80105884:	b8 03 00 00 00       	mov    $0x3,%eax
80105889:	89 f2                	mov    %esi,%edx
8010588b:	ee                   	out    %al,(%dx)
8010588c:	b2 fc                	mov    $0xfc,%dl
8010588e:	89 c8                	mov    %ecx,%eax
80105890:	ee                   	out    %al,(%dx)
80105891:	b8 01 00 00 00       	mov    $0x1,%eax
80105896:	89 da                	mov    %ebx,%edx
80105898:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105899:	b2 fd                	mov    $0xfd,%dl
8010589b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010589c:	3c ff                	cmp    $0xff,%al
8010589e:	74 42                	je     801058e2 <uartinit+0x92>
  uart = 1;
801058a0:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801058a7:	00 00 00 
801058aa:	89 fa                	mov    %edi,%edx
801058ac:	ec                   	in     (%dx),%al
801058ad:	b2 f8                	mov    $0xf8,%dl
801058af:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801058b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058b7:	00 
  for(p="xv6...\n"; *p; p++)
801058b8:	bb e8 76 10 80       	mov    $0x801076e8,%ebx
  ioapicenable(IRQ_COM1, 0);
801058bd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801058c4:	e8 d7 c9 ff ff       	call   801022a0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801058c9:	b8 78 00 00 00       	mov    $0x78,%eax
801058ce:	66 90                	xchg   %ax,%ax
    uartputc(*p);
801058d0:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
801058d3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
801058d6:	e8 25 ff ff ff       	call   80105800 <uartputc>
  for(p="xv6...\n"; *p; p++)
801058db:	0f be 03             	movsbl (%ebx),%eax
801058de:	84 c0                	test   %al,%al
801058e0:	75 ee                	jne    801058d0 <uartinit+0x80>
}
801058e2:	83 c4 1c             	add    $0x1c,%esp
801058e5:	5b                   	pop    %ebx
801058e6:	5e                   	pop    %esi
801058e7:	5f                   	pop    %edi
801058e8:	5d                   	pop    %ebp
801058e9:	c3                   	ret    
801058ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058f0 <uartintr>:

void
uartintr(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801058f6:	c7 04 24 d0 57 10 80 	movl   $0x801057d0,(%esp)
801058fd:	e8 ae ae ff ff       	call   801007b0 <consoleintr>
}
80105902:	c9                   	leave  
80105903:	c3                   	ret    

80105904 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105904:	6a 00                	push   $0x0
  pushl $0
80105906:	6a 00                	push   $0x0
  jmp alltraps
80105908:	e9 60 fb ff ff       	jmp    8010546d <alltraps>

8010590d <vector1>:
.globl vector1
vector1:
  pushl $0
8010590d:	6a 00                	push   $0x0
  pushl $1
8010590f:	6a 01                	push   $0x1
  jmp alltraps
80105911:	e9 57 fb ff ff       	jmp    8010546d <alltraps>

80105916 <vector2>:
.globl vector2
vector2:
  pushl $0
80105916:	6a 00                	push   $0x0
  pushl $2
80105918:	6a 02                	push   $0x2
  jmp alltraps
8010591a:	e9 4e fb ff ff       	jmp    8010546d <alltraps>

8010591f <vector3>:
.globl vector3
vector3:
  pushl $0
8010591f:	6a 00                	push   $0x0
  pushl $3
80105921:	6a 03                	push   $0x3
  jmp alltraps
80105923:	e9 45 fb ff ff       	jmp    8010546d <alltraps>

80105928 <vector4>:
.globl vector4
vector4:
  pushl $0
80105928:	6a 00                	push   $0x0
  pushl $4
8010592a:	6a 04                	push   $0x4
  jmp alltraps
8010592c:	e9 3c fb ff ff       	jmp    8010546d <alltraps>

80105931 <vector5>:
.globl vector5
vector5:
  pushl $0
80105931:	6a 00                	push   $0x0
  pushl $5
80105933:	6a 05                	push   $0x5
  jmp alltraps
80105935:	e9 33 fb ff ff       	jmp    8010546d <alltraps>

8010593a <vector6>:
.globl vector6
vector6:
  pushl $0
8010593a:	6a 00                	push   $0x0
  pushl $6
8010593c:	6a 06                	push   $0x6
  jmp alltraps
8010593e:	e9 2a fb ff ff       	jmp    8010546d <alltraps>

80105943 <vector7>:
.globl vector7
vector7:
  pushl $0
80105943:	6a 00                	push   $0x0
  pushl $7
80105945:	6a 07                	push   $0x7
  jmp alltraps
80105947:	e9 21 fb ff ff       	jmp    8010546d <alltraps>

8010594c <vector8>:
.globl vector8
vector8:
  pushl $8
8010594c:	6a 08                	push   $0x8
  jmp alltraps
8010594e:	e9 1a fb ff ff       	jmp    8010546d <alltraps>

80105953 <vector9>:
.globl vector9
vector9:
  pushl $0
80105953:	6a 00                	push   $0x0
  pushl $9
80105955:	6a 09                	push   $0x9
  jmp alltraps
80105957:	e9 11 fb ff ff       	jmp    8010546d <alltraps>

8010595c <vector10>:
.globl vector10
vector10:
  pushl $10
8010595c:	6a 0a                	push   $0xa
  jmp alltraps
8010595e:	e9 0a fb ff ff       	jmp    8010546d <alltraps>

80105963 <vector11>:
.globl vector11
vector11:
  pushl $11
80105963:	6a 0b                	push   $0xb
  jmp alltraps
80105965:	e9 03 fb ff ff       	jmp    8010546d <alltraps>

8010596a <vector12>:
.globl vector12
vector12:
  pushl $12
8010596a:	6a 0c                	push   $0xc
  jmp alltraps
8010596c:	e9 fc fa ff ff       	jmp    8010546d <alltraps>

80105971 <vector13>:
.globl vector13
vector13:
  pushl $13
80105971:	6a 0d                	push   $0xd
  jmp alltraps
80105973:	e9 f5 fa ff ff       	jmp    8010546d <alltraps>

80105978 <vector14>:
.globl vector14
vector14:
  pushl $14
80105978:	6a 0e                	push   $0xe
  jmp alltraps
8010597a:	e9 ee fa ff ff       	jmp    8010546d <alltraps>

8010597f <vector15>:
.globl vector15
vector15:
  pushl $0
8010597f:	6a 00                	push   $0x0
  pushl $15
80105981:	6a 0f                	push   $0xf
  jmp alltraps
80105983:	e9 e5 fa ff ff       	jmp    8010546d <alltraps>

80105988 <vector16>:
.globl vector16
vector16:
  pushl $0
80105988:	6a 00                	push   $0x0
  pushl $16
8010598a:	6a 10                	push   $0x10
  jmp alltraps
8010598c:	e9 dc fa ff ff       	jmp    8010546d <alltraps>

80105991 <vector17>:
.globl vector17
vector17:
  pushl $17
80105991:	6a 11                	push   $0x11
  jmp alltraps
80105993:	e9 d5 fa ff ff       	jmp    8010546d <alltraps>

80105998 <vector18>:
.globl vector18
vector18:
  pushl $0
80105998:	6a 00                	push   $0x0
  pushl $18
8010599a:	6a 12                	push   $0x12
  jmp alltraps
8010599c:	e9 cc fa ff ff       	jmp    8010546d <alltraps>

801059a1 <vector19>:
.globl vector19
vector19:
  pushl $0
801059a1:	6a 00                	push   $0x0
  pushl $19
801059a3:	6a 13                	push   $0x13
  jmp alltraps
801059a5:	e9 c3 fa ff ff       	jmp    8010546d <alltraps>

801059aa <vector20>:
.globl vector20
vector20:
  pushl $0
801059aa:	6a 00                	push   $0x0
  pushl $20
801059ac:	6a 14                	push   $0x14
  jmp alltraps
801059ae:	e9 ba fa ff ff       	jmp    8010546d <alltraps>

801059b3 <vector21>:
.globl vector21
vector21:
  pushl $0
801059b3:	6a 00                	push   $0x0
  pushl $21
801059b5:	6a 15                	push   $0x15
  jmp alltraps
801059b7:	e9 b1 fa ff ff       	jmp    8010546d <alltraps>

801059bc <vector22>:
.globl vector22
vector22:
  pushl $0
801059bc:	6a 00                	push   $0x0
  pushl $22
801059be:	6a 16                	push   $0x16
  jmp alltraps
801059c0:	e9 a8 fa ff ff       	jmp    8010546d <alltraps>

801059c5 <vector23>:
.globl vector23
vector23:
  pushl $0
801059c5:	6a 00                	push   $0x0
  pushl $23
801059c7:	6a 17                	push   $0x17
  jmp alltraps
801059c9:	e9 9f fa ff ff       	jmp    8010546d <alltraps>

801059ce <vector24>:
.globl vector24
vector24:
  pushl $0
801059ce:	6a 00                	push   $0x0
  pushl $24
801059d0:	6a 18                	push   $0x18
  jmp alltraps
801059d2:	e9 96 fa ff ff       	jmp    8010546d <alltraps>

801059d7 <vector25>:
.globl vector25
vector25:
  pushl $0
801059d7:	6a 00                	push   $0x0
  pushl $25
801059d9:	6a 19                	push   $0x19
  jmp alltraps
801059db:	e9 8d fa ff ff       	jmp    8010546d <alltraps>

801059e0 <vector26>:
.globl vector26
vector26:
  pushl $0
801059e0:	6a 00                	push   $0x0
  pushl $26
801059e2:	6a 1a                	push   $0x1a
  jmp alltraps
801059e4:	e9 84 fa ff ff       	jmp    8010546d <alltraps>

801059e9 <vector27>:
.globl vector27
vector27:
  pushl $0
801059e9:	6a 00                	push   $0x0
  pushl $27
801059eb:	6a 1b                	push   $0x1b
  jmp alltraps
801059ed:	e9 7b fa ff ff       	jmp    8010546d <alltraps>

801059f2 <vector28>:
.globl vector28
vector28:
  pushl $0
801059f2:	6a 00                	push   $0x0
  pushl $28
801059f4:	6a 1c                	push   $0x1c
  jmp alltraps
801059f6:	e9 72 fa ff ff       	jmp    8010546d <alltraps>

801059fb <vector29>:
.globl vector29
vector29:
  pushl $0
801059fb:	6a 00                	push   $0x0
  pushl $29
801059fd:	6a 1d                	push   $0x1d
  jmp alltraps
801059ff:	e9 69 fa ff ff       	jmp    8010546d <alltraps>

80105a04 <vector30>:
.globl vector30
vector30:
  pushl $0
80105a04:	6a 00                	push   $0x0
  pushl $30
80105a06:	6a 1e                	push   $0x1e
  jmp alltraps
80105a08:	e9 60 fa ff ff       	jmp    8010546d <alltraps>

80105a0d <vector31>:
.globl vector31
vector31:
  pushl $0
80105a0d:	6a 00                	push   $0x0
  pushl $31
80105a0f:	6a 1f                	push   $0x1f
  jmp alltraps
80105a11:	e9 57 fa ff ff       	jmp    8010546d <alltraps>

80105a16 <vector32>:
.globl vector32
vector32:
  pushl $0
80105a16:	6a 00                	push   $0x0
  pushl $32
80105a18:	6a 20                	push   $0x20
  jmp alltraps
80105a1a:	e9 4e fa ff ff       	jmp    8010546d <alltraps>

80105a1f <vector33>:
.globl vector33
vector33:
  pushl $0
80105a1f:	6a 00                	push   $0x0
  pushl $33
80105a21:	6a 21                	push   $0x21
  jmp alltraps
80105a23:	e9 45 fa ff ff       	jmp    8010546d <alltraps>

80105a28 <vector34>:
.globl vector34
vector34:
  pushl $0
80105a28:	6a 00                	push   $0x0
  pushl $34
80105a2a:	6a 22                	push   $0x22
  jmp alltraps
80105a2c:	e9 3c fa ff ff       	jmp    8010546d <alltraps>

80105a31 <vector35>:
.globl vector35
vector35:
  pushl $0
80105a31:	6a 00                	push   $0x0
  pushl $35
80105a33:	6a 23                	push   $0x23
  jmp alltraps
80105a35:	e9 33 fa ff ff       	jmp    8010546d <alltraps>

80105a3a <vector36>:
.globl vector36
vector36:
  pushl $0
80105a3a:	6a 00                	push   $0x0
  pushl $36
80105a3c:	6a 24                	push   $0x24
  jmp alltraps
80105a3e:	e9 2a fa ff ff       	jmp    8010546d <alltraps>

80105a43 <vector37>:
.globl vector37
vector37:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $37
80105a45:	6a 25                	push   $0x25
  jmp alltraps
80105a47:	e9 21 fa ff ff       	jmp    8010546d <alltraps>

80105a4c <vector38>:
.globl vector38
vector38:
  pushl $0
80105a4c:	6a 00                	push   $0x0
  pushl $38
80105a4e:	6a 26                	push   $0x26
  jmp alltraps
80105a50:	e9 18 fa ff ff       	jmp    8010546d <alltraps>

80105a55 <vector39>:
.globl vector39
vector39:
  pushl $0
80105a55:	6a 00                	push   $0x0
  pushl $39
80105a57:	6a 27                	push   $0x27
  jmp alltraps
80105a59:	e9 0f fa ff ff       	jmp    8010546d <alltraps>

80105a5e <vector40>:
.globl vector40
vector40:
  pushl $0
80105a5e:	6a 00                	push   $0x0
  pushl $40
80105a60:	6a 28                	push   $0x28
  jmp alltraps
80105a62:	e9 06 fa ff ff       	jmp    8010546d <alltraps>

80105a67 <vector41>:
.globl vector41
vector41:
  pushl $0
80105a67:	6a 00                	push   $0x0
  pushl $41
80105a69:	6a 29                	push   $0x29
  jmp alltraps
80105a6b:	e9 fd f9 ff ff       	jmp    8010546d <alltraps>

80105a70 <vector42>:
.globl vector42
vector42:
  pushl $0
80105a70:	6a 00                	push   $0x0
  pushl $42
80105a72:	6a 2a                	push   $0x2a
  jmp alltraps
80105a74:	e9 f4 f9 ff ff       	jmp    8010546d <alltraps>

80105a79 <vector43>:
.globl vector43
vector43:
  pushl $0
80105a79:	6a 00                	push   $0x0
  pushl $43
80105a7b:	6a 2b                	push   $0x2b
  jmp alltraps
80105a7d:	e9 eb f9 ff ff       	jmp    8010546d <alltraps>

80105a82 <vector44>:
.globl vector44
vector44:
  pushl $0
80105a82:	6a 00                	push   $0x0
  pushl $44
80105a84:	6a 2c                	push   $0x2c
  jmp alltraps
80105a86:	e9 e2 f9 ff ff       	jmp    8010546d <alltraps>

80105a8b <vector45>:
.globl vector45
vector45:
  pushl $0
80105a8b:	6a 00                	push   $0x0
  pushl $45
80105a8d:	6a 2d                	push   $0x2d
  jmp alltraps
80105a8f:	e9 d9 f9 ff ff       	jmp    8010546d <alltraps>

80105a94 <vector46>:
.globl vector46
vector46:
  pushl $0
80105a94:	6a 00                	push   $0x0
  pushl $46
80105a96:	6a 2e                	push   $0x2e
  jmp alltraps
80105a98:	e9 d0 f9 ff ff       	jmp    8010546d <alltraps>

80105a9d <vector47>:
.globl vector47
vector47:
  pushl $0
80105a9d:	6a 00                	push   $0x0
  pushl $47
80105a9f:	6a 2f                	push   $0x2f
  jmp alltraps
80105aa1:	e9 c7 f9 ff ff       	jmp    8010546d <alltraps>

80105aa6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105aa6:	6a 00                	push   $0x0
  pushl $48
80105aa8:	6a 30                	push   $0x30
  jmp alltraps
80105aaa:	e9 be f9 ff ff       	jmp    8010546d <alltraps>

80105aaf <vector49>:
.globl vector49
vector49:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $49
80105ab1:	6a 31                	push   $0x31
  jmp alltraps
80105ab3:	e9 b5 f9 ff ff       	jmp    8010546d <alltraps>

80105ab8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105ab8:	6a 00                	push   $0x0
  pushl $50
80105aba:	6a 32                	push   $0x32
  jmp alltraps
80105abc:	e9 ac f9 ff ff       	jmp    8010546d <alltraps>

80105ac1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105ac1:	6a 00                	push   $0x0
  pushl $51
80105ac3:	6a 33                	push   $0x33
  jmp alltraps
80105ac5:	e9 a3 f9 ff ff       	jmp    8010546d <alltraps>

80105aca <vector52>:
.globl vector52
vector52:
  pushl $0
80105aca:	6a 00                	push   $0x0
  pushl $52
80105acc:	6a 34                	push   $0x34
  jmp alltraps
80105ace:	e9 9a f9 ff ff       	jmp    8010546d <alltraps>

80105ad3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $53
80105ad5:	6a 35                	push   $0x35
  jmp alltraps
80105ad7:	e9 91 f9 ff ff       	jmp    8010546d <alltraps>

80105adc <vector54>:
.globl vector54
vector54:
  pushl $0
80105adc:	6a 00                	push   $0x0
  pushl $54
80105ade:	6a 36                	push   $0x36
  jmp alltraps
80105ae0:	e9 88 f9 ff ff       	jmp    8010546d <alltraps>

80105ae5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105ae5:	6a 00                	push   $0x0
  pushl $55
80105ae7:	6a 37                	push   $0x37
  jmp alltraps
80105ae9:	e9 7f f9 ff ff       	jmp    8010546d <alltraps>

80105aee <vector56>:
.globl vector56
vector56:
  pushl $0
80105aee:	6a 00                	push   $0x0
  pushl $56
80105af0:	6a 38                	push   $0x38
  jmp alltraps
80105af2:	e9 76 f9 ff ff       	jmp    8010546d <alltraps>

80105af7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $57
80105af9:	6a 39                	push   $0x39
  jmp alltraps
80105afb:	e9 6d f9 ff ff       	jmp    8010546d <alltraps>

80105b00 <vector58>:
.globl vector58
vector58:
  pushl $0
80105b00:	6a 00                	push   $0x0
  pushl $58
80105b02:	6a 3a                	push   $0x3a
  jmp alltraps
80105b04:	e9 64 f9 ff ff       	jmp    8010546d <alltraps>

80105b09 <vector59>:
.globl vector59
vector59:
  pushl $0
80105b09:	6a 00                	push   $0x0
  pushl $59
80105b0b:	6a 3b                	push   $0x3b
  jmp alltraps
80105b0d:	e9 5b f9 ff ff       	jmp    8010546d <alltraps>

80105b12 <vector60>:
.globl vector60
vector60:
  pushl $0
80105b12:	6a 00                	push   $0x0
  pushl $60
80105b14:	6a 3c                	push   $0x3c
  jmp alltraps
80105b16:	e9 52 f9 ff ff       	jmp    8010546d <alltraps>

80105b1b <vector61>:
.globl vector61
vector61:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $61
80105b1d:	6a 3d                	push   $0x3d
  jmp alltraps
80105b1f:	e9 49 f9 ff ff       	jmp    8010546d <alltraps>

80105b24 <vector62>:
.globl vector62
vector62:
  pushl $0
80105b24:	6a 00                	push   $0x0
  pushl $62
80105b26:	6a 3e                	push   $0x3e
  jmp alltraps
80105b28:	e9 40 f9 ff ff       	jmp    8010546d <alltraps>

80105b2d <vector63>:
.globl vector63
vector63:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $63
80105b2f:	6a 3f                	push   $0x3f
  jmp alltraps
80105b31:	e9 37 f9 ff ff       	jmp    8010546d <alltraps>

80105b36 <vector64>:
.globl vector64
vector64:
  pushl $0
80105b36:	6a 00                	push   $0x0
  pushl $64
80105b38:	6a 40                	push   $0x40
  jmp alltraps
80105b3a:	e9 2e f9 ff ff       	jmp    8010546d <alltraps>

80105b3f <vector65>:
.globl vector65
vector65:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $65
80105b41:	6a 41                	push   $0x41
  jmp alltraps
80105b43:	e9 25 f9 ff ff       	jmp    8010546d <alltraps>

80105b48 <vector66>:
.globl vector66
vector66:
  pushl $0
80105b48:	6a 00                	push   $0x0
  pushl $66
80105b4a:	6a 42                	push   $0x42
  jmp alltraps
80105b4c:	e9 1c f9 ff ff       	jmp    8010546d <alltraps>

80105b51 <vector67>:
.globl vector67
vector67:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $67
80105b53:	6a 43                	push   $0x43
  jmp alltraps
80105b55:	e9 13 f9 ff ff       	jmp    8010546d <alltraps>

80105b5a <vector68>:
.globl vector68
vector68:
  pushl $0
80105b5a:	6a 00                	push   $0x0
  pushl $68
80105b5c:	6a 44                	push   $0x44
  jmp alltraps
80105b5e:	e9 0a f9 ff ff       	jmp    8010546d <alltraps>

80105b63 <vector69>:
.globl vector69
vector69:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $69
80105b65:	6a 45                	push   $0x45
  jmp alltraps
80105b67:	e9 01 f9 ff ff       	jmp    8010546d <alltraps>

80105b6c <vector70>:
.globl vector70
vector70:
  pushl $0
80105b6c:	6a 00                	push   $0x0
  pushl $70
80105b6e:	6a 46                	push   $0x46
  jmp alltraps
80105b70:	e9 f8 f8 ff ff       	jmp    8010546d <alltraps>

80105b75 <vector71>:
.globl vector71
vector71:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $71
80105b77:	6a 47                	push   $0x47
  jmp alltraps
80105b79:	e9 ef f8 ff ff       	jmp    8010546d <alltraps>

80105b7e <vector72>:
.globl vector72
vector72:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $72
80105b80:	6a 48                	push   $0x48
  jmp alltraps
80105b82:	e9 e6 f8 ff ff       	jmp    8010546d <alltraps>

80105b87 <vector73>:
.globl vector73
vector73:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $73
80105b89:	6a 49                	push   $0x49
  jmp alltraps
80105b8b:	e9 dd f8 ff ff       	jmp    8010546d <alltraps>

80105b90 <vector74>:
.globl vector74
vector74:
  pushl $0
80105b90:	6a 00                	push   $0x0
  pushl $74
80105b92:	6a 4a                	push   $0x4a
  jmp alltraps
80105b94:	e9 d4 f8 ff ff       	jmp    8010546d <alltraps>

80105b99 <vector75>:
.globl vector75
vector75:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $75
80105b9b:	6a 4b                	push   $0x4b
  jmp alltraps
80105b9d:	e9 cb f8 ff ff       	jmp    8010546d <alltraps>

80105ba2 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $76
80105ba4:	6a 4c                	push   $0x4c
  jmp alltraps
80105ba6:	e9 c2 f8 ff ff       	jmp    8010546d <alltraps>

80105bab <vector77>:
.globl vector77
vector77:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $77
80105bad:	6a 4d                	push   $0x4d
  jmp alltraps
80105baf:	e9 b9 f8 ff ff       	jmp    8010546d <alltraps>

80105bb4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $78
80105bb6:	6a 4e                	push   $0x4e
  jmp alltraps
80105bb8:	e9 b0 f8 ff ff       	jmp    8010546d <alltraps>

80105bbd <vector79>:
.globl vector79
vector79:
  pushl $0
80105bbd:	6a 00                	push   $0x0
  pushl $79
80105bbf:	6a 4f                	push   $0x4f
  jmp alltraps
80105bc1:	e9 a7 f8 ff ff       	jmp    8010546d <alltraps>

80105bc6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105bc6:	6a 00                	push   $0x0
  pushl $80
80105bc8:	6a 50                	push   $0x50
  jmp alltraps
80105bca:	e9 9e f8 ff ff       	jmp    8010546d <alltraps>

80105bcf <vector81>:
.globl vector81
vector81:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $81
80105bd1:	6a 51                	push   $0x51
  jmp alltraps
80105bd3:	e9 95 f8 ff ff       	jmp    8010546d <alltraps>

80105bd8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105bd8:	6a 00                	push   $0x0
  pushl $82
80105bda:	6a 52                	push   $0x52
  jmp alltraps
80105bdc:	e9 8c f8 ff ff       	jmp    8010546d <alltraps>

80105be1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105be1:	6a 00                	push   $0x0
  pushl $83
80105be3:	6a 53                	push   $0x53
  jmp alltraps
80105be5:	e9 83 f8 ff ff       	jmp    8010546d <alltraps>

80105bea <vector84>:
.globl vector84
vector84:
  pushl $0
80105bea:	6a 00                	push   $0x0
  pushl $84
80105bec:	6a 54                	push   $0x54
  jmp alltraps
80105bee:	e9 7a f8 ff ff       	jmp    8010546d <alltraps>

80105bf3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $85
80105bf5:	6a 55                	push   $0x55
  jmp alltraps
80105bf7:	e9 71 f8 ff ff       	jmp    8010546d <alltraps>

80105bfc <vector86>:
.globl vector86
vector86:
  pushl $0
80105bfc:	6a 00                	push   $0x0
  pushl $86
80105bfe:	6a 56                	push   $0x56
  jmp alltraps
80105c00:	e9 68 f8 ff ff       	jmp    8010546d <alltraps>

80105c05 <vector87>:
.globl vector87
vector87:
  pushl $0
80105c05:	6a 00                	push   $0x0
  pushl $87
80105c07:	6a 57                	push   $0x57
  jmp alltraps
80105c09:	e9 5f f8 ff ff       	jmp    8010546d <alltraps>

80105c0e <vector88>:
.globl vector88
vector88:
  pushl $0
80105c0e:	6a 00                	push   $0x0
  pushl $88
80105c10:	6a 58                	push   $0x58
  jmp alltraps
80105c12:	e9 56 f8 ff ff       	jmp    8010546d <alltraps>

80105c17 <vector89>:
.globl vector89
vector89:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $89
80105c19:	6a 59                	push   $0x59
  jmp alltraps
80105c1b:	e9 4d f8 ff ff       	jmp    8010546d <alltraps>

80105c20 <vector90>:
.globl vector90
vector90:
  pushl $0
80105c20:	6a 00                	push   $0x0
  pushl $90
80105c22:	6a 5a                	push   $0x5a
  jmp alltraps
80105c24:	e9 44 f8 ff ff       	jmp    8010546d <alltraps>

80105c29 <vector91>:
.globl vector91
vector91:
  pushl $0
80105c29:	6a 00                	push   $0x0
  pushl $91
80105c2b:	6a 5b                	push   $0x5b
  jmp alltraps
80105c2d:	e9 3b f8 ff ff       	jmp    8010546d <alltraps>

80105c32 <vector92>:
.globl vector92
vector92:
  pushl $0
80105c32:	6a 00                	push   $0x0
  pushl $92
80105c34:	6a 5c                	push   $0x5c
  jmp alltraps
80105c36:	e9 32 f8 ff ff       	jmp    8010546d <alltraps>

80105c3b <vector93>:
.globl vector93
vector93:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $93
80105c3d:	6a 5d                	push   $0x5d
  jmp alltraps
80105c3f:	e9 29 f8 ff ff       	jmp    8010546d <alltraps>

80105c44 <vector94>:
.globl vector94
vector94:
  pushl $0
80105c44:	6a 00                	push   $0x0
  pushl $94
80105c46:	6a 5e                	push   $0x5e
  jmp alltraps
80105c48:	e9 20 f8 ff ff       	jmp    8010546d <alltraps>

80105c4d <vector95>:
.globl vector95
vector95:
  pushl $0
80105c4d:	6a 00                	push   $0x0
  pushl $95
80105c4f:	6a 5f                	push   $0x5f
  jmp alltraps
80105c51:	e9 17 f8 ff ff       	jmp    8010546d <alltraps>

80105c56 <vector96>:
.globl vector96
vector96:
  pushl $0
80105c56:	6a 00                	push   $0x0
  pushl $96
80105c58:	6a 60                	push   $0x60
  jmp alltraps
80105c5a:	e9 0e f8 ff ff       	jmp    8010546d <alltraps>

80105c5f <vector97>:
.globl vector97
vector97:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $97
80105c61:	6a 61                	push   $0x61
  jmp alltraps
80105c63:	e9 05 f8 ff ff       	jmp    8010546d <alltraps>

80105c68 <vector98>:
.globl vector98
vector98:
  pushl $0
80105c68:	6a 00                	push   $0x0
  pushl $98
80105c6a:	6a 62                	push   $0x62
  jmp alltraps
80105c6c:	e9 fc f7 ff ff       	jmp    8010546d <alltraps>

80105c71 <vector99>:
.globl vector99
vector99:
  pushl $0
80105c71:	6a 00                	push   $0x0
  pushl $99
80105c73:	6a 63                	push   $0x63
  jmp alltraps
80105c75:	e9 f3 f7 ff ff       	jmp    8010546d <alltraps>

80105c7a <vector100>:
.globl vector100
vector100:
  pushl $0
80105c7a:	6a 00                	push   $0x0
  pushl $100
80105c7c:	6a 64                	push   $0x64
  jmp alltraps
80105c7e:	e9 ea f7 ff ff       	jmp    8010546d <alltraps>

80105c83 <vector101>:
.globl vector101
vector101:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $101
80105c85:	6a 65                	push   $0x65
  jmp alltraps
80105c87:	e9 e1 f7 ff ff       	jmp    8010546d <alltraps>

80105c8c <vector102>:
.globl vector102
vector102:
  pushl $0
80105c8c:	6a 00                	push   $0x0
  pushl $102
80105c8e:	6a 66                	push   $0x66
  jmp alltraps
80105c90:	e9 d8 f7 ff ff       	jmp    8010546d <alltraps>

80105c95 <vector103>:
.globl vector103
vector103:
  pushl $0
80105c95:	6a 00                	push   $0x0
  pushl $103
80105c97:	6a 67                	push   $0x67
  jmp alltraps
80105c99:	e9 cf f7 ff ff       	jmp    8010546d <alltraps>

80105c9e <vector104>:
.globl vector104
vector104:
  pushl $0
80105c9e:	6a 00                	push   $0x0
  pushl $104
80105ca0:	6a 68                	push   $0x68
  jmp alltraps
80105ca2:	e9 c6 f7 ff ff       	jmp    8010546d <alltraps>

80105ca7 <vector105>:
.globl vector105
vector105:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $105
80105ca9:	6a 69                	push   $0x69
  jmp alltraps
80105cab:	e9 bd f7 ff ff       	jmp    8010546d <alltraps>

80105cb0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105cb0:	6a 00                	push   $0x0
  pushl $106
80105cb2:	6a 6a                	push   $0x6a
  jmp alltraps
80105cb4:	e9 b4 f7 ff ff       	jmp    8010546d <alltraps>

80105cb9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $107
80105cbb:	6a 6b                	push   $0x6b
  jmp alltraps
80105cbd:	e9 ab f7 ff ff       	jmp    8010546d <alltraps>

80105cc2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105cc2:	6a 00                	push   $0x0
  pushl $108
80105cc4:	6a 6c                	push   $0x6c
  jmp alltraps
80105cc6:	e9 a2 f7 ff ff       	jmp    8010546d <alltraps>

80105ccb <vector109>:
.globl vector109
vector109:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $109
80105ccd:	6a 6d                	push   $0x6d
  jmp alltraps
80105ccf:	e9 99 f7 ff ff       	jmp    8010546d <alltraps>

80105cd4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105cd4:	6a 00                	push   $0x0
  pushl $110
80105cd6:	6a 6e                	push   $0x6e
  jmp alltraps
80105cd8:	e9 90 f7 ff ff       	jmp    8010546d <alltraps>

80105cdd <vector111>:
.globl vector111
vector111:
  pushl $0
80105cdd:	6a 00                	push   $0x0
  pushl $111
80105cdf:	6a 6f                	push   $0x6f
  jmp alltraps
80105ce1:	e9 87 f7 ff ff       	jmp    8010546d <alltraps>

80105ce6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105ce6:	6a 00                	push   $0x0
  pushl $112
80105ce8:	6a 70                	push   $0x70
  jmp alltraps
80105cea:	e9 7e f7 ff ff       	jmp    8010546d <alltraps>

80105cef <vector113>:
.globl vector113
vector113:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $113
80105cf1:	6a 71                	push   $0x71
  jmp alltraps
80105cf3:	e9 75 f7 ff ff       	jmp    8010546d <alltraps>

80105cf8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105cf8:	6a 00                	push   $0x0
  pushl $114
80105cfa:	6a 72                	push   $0x72
  jmp alltraps
80105cfc:	e9 6c f7 ff ff       	jmp    8010546d <alltraps>

80105d01 <vector115>:
.globl vector115
vector115:
  pushl $0
80105d01:	6a 00                	push   $0x0
  pushl $115
80105d03:	6a 73                	push   $0x73
  jmp alltraps
80105d05:	e9 63 f7 ff ff       	jmp    8010546d <alltraps>

80105d0a <vector116>:
.globl vector116
vector116:
  pushl $0
80105d0a:	6a 00                	push   $0x0
  pushl $116
80105d0c:	6a 74                	push   $0x74
  jmp alltraps
80105d0e:	e9 5a f7 ff ff       	jmp    8010546d <alltraps>

80105d13 <vector117>:
.globl vector117
vector117:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $117
80105d15:	6a 75                	push   $0x75
  jmp alltraps
80105d17:	e9 51 f7 ff ff       	jmp    8010546d <alltraps>

80105d1c <vector118>:
.globl vector118
vector118:
  pushl $0
80105d1c:	6a 00                	push   $0x0
  pushl $118
80105d1e:	6a 76                	push   $0x76
  jmp alltraps
80105d20:	e9 48 f7 ff ff       	jmp    8010546d <alltraps>

80105d25 <vector119>:
.globl vector119
vector119:
  pushl $0
80105d25:	6a 00                	push   $0x0
  pushl $119
80105d27:	6a 77                	push   $0x77
  jmp alltraps
80105d29:	e9 3f f7 ff ff       	jmp    8010546d <alltraps>

80105d2e <vector120>:
.globl vector120
vector120:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $120
80105d30:	6a 78                	push   $0x78
  jmp alltraps
80105d32:	e9 36 f7 ff ff       	jmp    8010546d <alltraps>

80105d37 <vector121>:
.globl vector121
vector121:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $121
80105d39:	6a 79                	push   $0x79
  jmp alltraps
80105d3b:	e9 2d f7 ff ff       	jmp    8010546d <alltraps>

80105d40 <vector122>:
.globl vector122
vector122:
  pushl $0
80105d40:	6a 00                	push   $0x0
  pushl $122
80105d42:	6a 7a                	push   $0x7a
  jmp alltraps
80105d44:	e9 24 f7 ff ff       	jmp    8010546d <alltraps>

80105d49 <vector123>:
.globl vector123
vector123:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $123
80105d4b:	6a 7b                	push   $0x7b
  jmp alltraps
80105d4d:	e9 1b f7 ff ff       	jmp    8010546d <alltraps>

80105d52 <vector124>:
.globl vector124
vector124:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $124
80105d54:	6a 7c                	push   $0x7c
  jmp alltraps
80105d56:	e9 12 f7 ff ff       	jmp    8010546d <alltraps>

80105d5b <vector125>:
.globl vector125
vector125:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $125
80105d5d:	6a 7d                	push   $0x7d
  jmp alltraps
80105d5f:	e9 09 f7 ff ff       	jmp    8010546d <alltraps>

80105d64 <vector126>:
.globl vector126
vector126:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $126
80105d66:	6a 7e                	push   $0x7e
  jmp alltraps
80105d68:	e9 00 f7 ff ff       	jmp    8010546d <alltraps>

80105d6d <vector127>:
.globl vector127
vector127:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $127
80105d6f:	6a 7f                	push   $0x7f
  jmp alltraps
80105d71:	e9 f7 f6 ff ff       	jmp    8010546d <alltraps>

80105d76 <vector128>:
.globl vector128
vector128:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $128
80105d78:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105d7d:	e9 eb f6 ff ff       	jmp    8010546d <alltraps>

80105d82 <vector129>:
.globl vector129
vector129:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $129
80105d84:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105d89:	e9 df f6 ff ff       	jmp    8010546d <alltraps>

80105d8e <vector130>:
.globl vector130
vector130:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $130
80105d90:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105d95:	e9 d3 f6 ff ff       	jmp    8010546d <alltraps>

80105d9a <vector131>:
.globl vector131
vector131:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $131
80105d9c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105da1:	e9 c7 f6 ff ff       	jmp    8010546d <alltraps>

80105da6 <vector132>:
.globl vector132
vector132:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $132
80105da8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105dad:	e9 bb f6 ff ff       	jmp    8010546d <alltraps>

80105db2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $133
80105db4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105db9:	e9 af f6 ff ff       	jmp    8010546d <alltraps>

80105dbe <vector134>:
.globl vector134
vector134:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $134
80105dc0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105dc5:	e9 a3 f6 ff ff       	jmp    8010546d <alltraps>

80105dca <vector135>:
.globl vector135
vector135:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $135
80105dcc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105dd1:	e9 97 f6 ff ff       	jmp    8010546d <alltraps>

80105dd6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $136
80105dd8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105ddd:	e9 8b f6 ff ff       	jmp    8010546d <alltraps>

80105de2 <vector137>:
.globl vector137
vector137:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $137
80105de4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105de9:	e9 7f f6 ff ff       	jmp    8010546d <alltraps>

80105dee <vector138>:
.globl vector138
vector138:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $138
80105df0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105df5:	e9 73 f6 ff ff       	jmp    8010546d <alltraps>

80105dfa <vector139>:
.globl vector139
vector139:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $139
80105dfc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105e01:	e9 67 f6 ff ff       	jmp    8010546d <alltraps>

80105e06 <vector140>:
.globl vector140
vector140:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $140
80105e08:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105e0d:	e9 5b f6 ff ff       	jmp    8010546d <alltraps>

80105e12 <vector141>:
.globl vector141
vector141:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $141
80105e14:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105e19:	e9 4f f6 ff ff       	jmp    8010546d <alltraps>

80105e1e <vector142>:
.globl vector142
vector142:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $142
80105e20:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105e25:	e9 43 f6 ff ff       	jmp    8010546d <alltraps>

80105e2a <vector143>:
.globl vector143
vector143:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $143
80105e2c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105e31:	e9 37 f6 ff ff       	jmp    8010546d <alltraps>

80105e36 <vector144>:
.globl vector144
vector144:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $144
80105e38:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105e3d:	e9 2b f6 ff ff       	jmp    8010546d <alltraps>

80105e42 <vector145>:
.globl vector145
vector145:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $145
80105e44:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105e49:	e9 1f f6 ff ff       	jmp    8010546d <alltraps>

80105e4e <vector146>:
.globl vector146
vector146:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $146
80105e50:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105e55:	e9 13 f6 ff ff       	jmp    8010546d <alltraps>

80105e5a <vector147>:
.globl vector147
vector147:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $147
80105e5c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105e61:	e9 07 f6 ff ff       	jmp    8010546d <alltraps>

80105e66 <vector148>:
.globl vector148
vector148:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $148
80105e68:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105e6d:	e9 fb f5 ff ff       	jmp    8010546d <alltraps>

80105e72 <vector149>:
.globl vector149
vector149:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $149
80105e74:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105e79:	e9 ef f5 ff ff       	jmp    8010546d <alltraps>

80105e7e <vector150>:
.globl vector150
vector150:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $150
80105e80:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105e85:	e9 e3 f5 ff ff       	jmp    8010546d <alltraps>

80105e8a <vector151>:
.globl vector151
vector151:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $151
80105e8c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105e91:	e9 d7 f5 ff ff       	jmp    8010546d <alltraps>

80105e96 <vector152>:
.globl vector152
vector152:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $152
80105e98:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105e9d:	e9 cb f5 ff ff       	jmp    8010546d <alltraps>

80105ea2 <vector153>:
.globl vector153
vector153:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $153
80105ea4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105ea9:	e9 bf f5 ff ff       	jmp    8010546d <alltraps>

80105eae <vector154>:
.globl vector154
vector154:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $154
80105eb0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105eb5:	e9 b3 f5 ff ff       	jmp    8010546d <alltraps>

80105eba <vector155>:
.globl vector155
vector155:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $155
80105ebc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105ec1:	e9 a7 f5 ff ff       	jmp    8010546d <alltraps>

80105ec6 <vector156>:
.globl vector156
vector156:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $156
80105ec8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105ecd:	e9 9b f5 ff ff       	jmp    8010546d <alltraps>

80105ed2 <vector157>:
.globl vector157
vector157:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $157
80105ed4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105ed9:	e9 8f f5 ff ff       	jmp    8010546d <alltraps>

80105ede <vector158>:
.globl vector158
vector158:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $158
80105ee0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105ee5:	e9 83 f5 ff ff       	jmp    8010546d <alltraps>

80105eea <vector159>:
.globl vector159
vector159:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $159
80105eec:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105ef1:	e9 77 f5 ff ff       	jmp    8010546d <alltraps>

80105ef6 <vector160>:
.globl vector160
vector160:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $160
80105ef8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105efd:	e9 6b f5 ff ff       	jmp    8010546d <alltraps>

80105f02 <vector161>:
.globl vector161
vector161:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $161
80105f04:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105f09:	e9 5f f5 ff ff       	jmp    8010546d <alltraps>

80105f0e <vector162>:
.globl vector162
vector162:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $162
80105f10:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105f15:	e9 53 f5 ff ff       	jmp    8010546d <alltraps>

80105f1a <vector163>:
.globl vector163
vector163:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $163
80105f1c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105f21:	e9 47 f5 ff ff       	jmp    8010546d <alltraps>

80105f26 <vector164>:
.globl vector164
vector164:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $164
80105f28:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105f2d:	e9 3b f5 ff ff       	jmp    8010546d <alltraps>

80105f32 <vector165>:
.globl vector165
vector165:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $165
80105f34:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105f39:	e9 2f f5 ff ff       	jmp    8010546d <alltraps>

80105f3e <vector166>:
.globl vector166
vector166:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $166
80105f40:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105f45:	e9 23 f5 ff ff       	jmp    8010546d <alltraps>

80105f4a <vector167>:
.globl vector167
vector167:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $167
80105f4c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105f51:	e9 17 f5 ff ff       	jmp    8010546d <alltraps>

80105f56 <vector168>:
.globl vector168
vector168:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $168
80105f58:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105f5d:	e9 0b f5 ff ff       	jmp    8010546d <alltraps>

80105f62 <vector169>:
.globl vector169
vector169:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $169
80105f64:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105f69:	e9 ff f4 ff ff       	jmp    8010546d <alltraps>

80105f6e <vector170>:
.globl vector170
vector170:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $170
80105f70:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105f75:	e9 f3 f4 ff ff       	jmp    8010546d <alltraps>

80105f7a <vector171>:
.globl vector171
vector171:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $171
80105f7c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105f81:	e9 e7 f4 ff ff       	jmp    8010546d <alltraps>

80105f86 <vector172>:
.globl vector172
vector172:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $172
80105f88:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105f8d:	e9 db f4 ff ff       	jmp    8010546d <alltraps>

80105f92 <vector173>:
.globl vector173
vector173:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $173
80105f94:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105f99:	e9 cf f4 ff ff       	jmp    8010546d <alltraps>

80105f9e <vector174>:
.globl vector174
vector174:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $174
80105fa0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105fa5:	e9 c3 f4 ff ff       	jmp    8010546d <alltraps>

80105faa <vector175>:
.globl vector175
vector175:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $175
80105fac:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105fb1:	e9 b7 f4 ff ff       	jmp    8010546d <alltraps>

80105fb6 <vector176>:
.globl vector176
vector176:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $176
80105fb8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105fbd:	e9 ab f4 ff ff       	jmp    8010546d <alltraps>

80105fc2 <vector177>:
.globl vector177
vector177:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $177
80105fc4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105fc9:	e9 9f f4 ff ff       	jmp    8010546d <alltraps>

80105fce <vector178>:
.globl vector178
vector178:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $178
80105fd0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105fd5:	e9 93 f4 ff ff       	jmp    8010546d <alltraps>

80105fda <vector179>:
.globl vector179
vector179:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $179
80105fdc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105fe1:	e9 87 f4 ff ff       	jmp    8010546d <alltraps>

80105fe6 <vector180>:
.globl vector180
vector180:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $180
80105fe8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105fed:	e9 7b f4 ff ff       	jmp    8010546d <alltraps>

80105ff2 <vector181>:
.globl vector181
vector181:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $181
80105ff4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105ff9:	e9 6f f4 ff ff       	jmp    8010546d <alltraps>

80105ffe <vector182>:
.globl vector182
vector182:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $182
80106000:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106005:	e9 63 f4 ff ff       	jmp    8010546d <alltraps>

8010600a <vector183>:
.globl vector183
vector183:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $183
8010600c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106011:	e9 57 f4 ff ff       	jmp    8010546d <alltraps>

80106016 <vector184>:
.globl vector184
vector184:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $184
80106018:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010601d:	e9 4b f4 ff ff       	jmp    8010546d <alltraps>

80106022 <vector185>:
.globl vector185
vector185:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $185
80106024:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106029:	e9 3f f4 ff ff       	jmp    8010546d <alltraps>

8010602e <vector186>:
.globl vector186
vector186:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $186
80106030:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106035:	e9 33 f4 ff ff       	jmp    8010546d <alltraps>

8010603a <vector187>:
.globl vector187
vector187:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $187
8010603c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106041:	e9 27 f4 ff ff       	jmp    8010546d <alltraps>

80106046 <vector188>:
.globl vector188
vector188:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $188
80106048:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010604d:	e9 1b f4 ff ff       	jmp    8010546d <alltraps>

80106052 <vector189>:
.globl vector189
vector189:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $189
80106054:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106059:	e9 0f f4 ff ff       	jmp    8010546d <alltraps>

8010605e <vector190>:
.globl vector190
vector190:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $190
80106060:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106065:	e9 03 f4 ff ff       	jmp    8010546d <alltraps>

8010606a <vector191>:
.globl vector191
vector191:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $191
8010606c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106071:	e9 f7 f3 ff ff       	jmp    8010546d <alltraps>

80106076 <vector192>:
.globl vector192
vector192:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $192
80106078:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010607d:	e9 eb f3 ff ff       	jmp    8010546d <alltraps>

80106082 <vector193>:
.globl vector193
vector193:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $193
80106084:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106089:	e9 df f3 ff ff       	jmp    8010546d <alltraps>

8010608e <vector194>:
.globl vector194
vector194:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $194
80106090:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106095:	e9 d3 f3 ff ff       	jmp    8010546d <alltraps>

8010609a <vector195>:
.globl vector195
vector195:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $195
8010609c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801060a1:	e9 c7 f3 ff ff       	jmp    8010546d <alltraps>

801060a6 <vector196>:
.globl vector196
vector196:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $196
801060a8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801060ad:	e9 bb f3 ff ff       	jmp    8010546d <alltraps>

801060b2 <vector197>:
.globl vector197
vector197:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $197
801060b4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801060b9:	e9 af f3 ff ff       	jmp    8010546d <alltraps>

801060be <vector198>:
.globl vector198
vector198:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $198
801060c0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801060c5:	e9 a3 f3 ff ff       	jmp    8010546d <alltraps>

801060ca <vector199>:
.globl vector199
vector199:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $199
801060cc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801060d1:	e9 97 f3 ff ff       	jmp    8010546d <alltraps>

801060d6 <vector200>:
.globl vector200
vector200:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $200
801060d8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801060dd:	e9 8b f3 ff ff       	jmp    8010546d <alltraps>

801060e2 <vector201>:
.globl vector201
vector201:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $201
801060e4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801060e9:	e9 7f f3 ff ff       	jmp    8010546d <alltraps>

801060ee <vector202>:
.globl vector202
vector202:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $202
801060f0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801060f5:	e9 73 f3 ff ff       	jmp    8010546d <alltraps>

801060fa <vector203>:
.globl vector203
vector203:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $203
801060fc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106101:	e9 67 f3 ff ff       	jmp    8010546d <alltraps>

80106106 <vector204>:
.globl vector204
vector204:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $204
80106108:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010610d:	e9 5b f3 ff ff       	jmp    8010546d <alltraps>

80106112 <vector205>:
.globl vector205
vector205:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $205
80106114:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106119:	e9 4f f3 ff ff       	jmp    8010546d <alltraps>

8010611e <vector206>:
.globl vector206
vector206:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $206
80106120:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106125:	e9 43 f3 ff ff       	jmp    8010546d <alltraps>

8010612a <vector207>:
.globl vector207
vector207:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $207
8010612c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106131:	e9 37 f3 ff ff       	jmp    8010546d <alltraps>

80106136 <vector208>:
.globl vector208
vector208:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $208
80106138:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010613d:	e9 2b f3 ff ff       	jmp    8010546d <alltraps>

80106142 <vector209>:
.globl vector209
vector209:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $209
80106144:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106149:	e9 1f f3 ff ff       	jmp    8010546d <alltraps>

8010614e <vector210>:
.globl vector210
vector210:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $210
80106150:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106155:	e9 13 f3 ff ff       	jmp    8010546d <alltraps>

8010615a <vector211>:
.globl vector211
vector211:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $211
8010615c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106161:	e9 07 f3 ff ff       	jmp    8010546d <alltraps>

80106166 <vector212>:
.globl vector212
vector212:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $212
80106168:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010616d:	e9 fb f2 ff ff       	jmp    8010546d <alltraps>

80106172 <vector213>:
.globl vector213
vector213:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $213
80106174:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106179:	e9 ef f2 ff ff       	jmp    8010546d <alltraps>

8010617e <vector214>:
.globl vector214
vector214:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $214
80106180:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106185:	e9 e3 f2 ff ff       	jmp    8010546d <alltraps>

8010618a <vector215>:
.globl vector215
vector215:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $215
8010618c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106191:	e9 d7 f2 ff ff       	jmp    8010546d <alltraps>

80106196 <vector216>:
.globl vector216
vector216:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $216
80106198:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010619d:	e9 cb f2 ff ff       	jmp    8010546d <alltraps>

801061a2 <vector217>:
.globl vector217
vector217:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $217
801061a4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801061a9:	e9 bf f2 ff ff       	jmp    8010546d <alltraps>

801061ae <vector218>:
.globl vector218
vector218:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $218
801061b0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801061b5:	e9 b3 f2 ff ff       	jmp    8010546d <alltraps>

801061ba <vector219>:
.globl vector219
vector219:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $219
801061bc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801061c1:	e9 a7 f2 ff ff       	jmp    8010546d <alltraps>

801061c6 <vector220>:
.globl vector220
vector220:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $220
801061c8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801061cd:	e9 9b f2 ff ff       	jmp    8010546d <alltraps>

801061d2 <vector221>:
.globl vector221
vector221:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $221
801061d4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801061d9:	e9 8f f2 ff ff       	jmp    8010546d <alltraps>

801061de <vector222>:
.globl vector222
vector222:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $222
801061e0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801061e5:	e9 83 f2 ff ff       	jmp    8010546d <alltraps>

801061ea <vector223>:
.globl vector223
vector223:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $223
801061ec:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801061f1:	e9 77 f2 ff ff       	jmp    8010546d <alltraps>

801061f6 <vector224>:
.globl vector224
vector224:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $224
801061f8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801061fd:	e9 6b f2 ff ff       	jmp    8010546d <alltraps>

80106202 <vector225>:
.globl vector225
vector225:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $225
80106204:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106209:	e9 5f f2 ff ff       	jmp    8010546d <alltraps>

8010620e <vector226>:
.globl vector226
vector226:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $226
80106210:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106215:	e9 53 f2 ff ff       	jmp    8010546d <alltraps>

8010621a <vector227>:
.globl vector227
vector227:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $227
8010621c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106221:	e9 47 f2 ff ff       	jmp    8010546d <alltraps>

80106226 <vector228>:
.globl vector228
vector228:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $228
80106228:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010622d:	e9 3b f2 ff ff       	jmp    8010546d <alltraps>

80106232 <vector229>:
.globl vector229
vector229:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $229
80106234:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106239:	e9 2f f2 ff ff       	jmp    8010546d <alltraps>

8010623e <vector230>:
.globl vector230
vector230:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $230
80106240:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106245:	e9 23 f2 ff ff       	jmp    8010546d <alltraps>

8010624a <vector231>:
.globl vector231
vector231:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $231
8010624c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106251:	e9 17 f2 ff ff       	jmp    8010546d <alltraps>

80106256 <vector232>:
.globl vector232
vector232:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $232
80106258:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010625d:	e9 0b f2 ff ff       	jmp    8010546d <alltraps>

80106262 <vector233>:
.globl vector233
vector233:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $233
80106264:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106269:	e9 ff f1 ff ff       	jmp    8010546d <alltraps>

8010626e <vector234>:
.globl vector234
vector234:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $234
80106270:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106275:	e9 f3 f1 ff ff       	jmp    8010546d <alltraps>

8010627a <vector235>:
.globl vector235
vector235:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $235
8010627c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106281:	e9 e7 f1 ff ff       	jmp    8010546d <alltraps>

80106286 <vector236>:
.globl vector236
vector236:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $236
80106288:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010628d:	e9 db f1 ff ff       	jmp    8010546d <alltraps>

80106292 <vector237>:
.globl vector237
vector237:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $237
80106294:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106299:	e9 cf f1 ff ff       	jmp    8010546d <alltraps>

8010629e <vector238>:
.globl vector238
vector238:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $238
801062a0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801062a5:	e9 c3 f1 ff ff       	jmp    8010546d <alltraps>

801062aa <vector239>:
.globl vector239
vector239:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $239
801062ac:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801062b1:	e9 b7 f1 ff ff       	jmp    8010546d <alltraps>

801062b6 <vector240>:
.globl vector240
vector240:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $240
801062b8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801062bd:	e9 ab f1 ff ff       	jmp    8010546d <alltraps>

801062c2 <vector241>:
.globl vector241
vector241:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $241
801062c4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801062c9:	e9 9f f1 ff ff       	jmp    8010546d <alltraps>

801062ce <vector242>:
.globl vector242
vector242:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $242
801062d0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801062d5:	e9 93 f1 ff ff       	jmp    8010546d <alltraps>

801062da <vector243>:
.globl vector243
vector243:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $243
801062dc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801062e1:	e9 87 f1 ff ff       	jmp    8010546d <alltraps>

801062e6 <vector244>:
.globl vector244
vector244:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $244
801062e8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801062ed:	e9 7b f1 ff ff       	jmp    8010546d <alltraps>

801062f2 <vector245>:
.globl vector245
vector245:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $245
801062f4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801062f9:	e9 6f f1 ff ff       	jmp    8010546d <alltraps>

801062fe <vector246>:
.globl vector246
vector246:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $246
80106300:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106305:	e9 63 f1 ff ff       	jmp    8010546d <alltraps>

8010630a <vector247>:
.globl vector247
vector247:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $247
8010630c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106311:	e9 57 f1 ff ff       	jmp    8010546d <alltraps>

80106316 <vector248>:
.globl vector248
vector248:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $248
80106318:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010631d:	e9 4b f1 ff ff       	jmp    8010546d <alltraps>

80106322 <vector249>:
.globl vector249
vector249:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $249
80106324:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106329:	e9 3f f1 ff ff       	jmp    8010546d <alltraps>

8010632e <vector250>:
.globl vector250
vector250:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $250
80106330:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106335:	e9 33 f1 ff ff       	jmp    8010546d <alltraps>

8010633a <vector251>:
.globl vector251
vector251:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $251
8010633c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106341:	e9 27 f1 ff ff       	jmp    8010546d <alltraps>

80106346 <vector252>:
.globl vector252
vector252:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $252
80106348:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010634d:	e9 1b f1 ff ff       	jmp    8010546d <alltraps>

80106352 <vector253>:
.globl vector253
vector253:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $253
80106354:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106359:	e9 0f f1 ff ff       	jmp    8010546d <alltraps>

8010635e <vector254>:
.globl vector254
vector254:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $254
80106360:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106365:	e9 03 f1 ff ff       	jmp    8010546d <alltraps>

8010636a <vector255>:
.globl vector255
vector255:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $255
8010636c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106371:	e9 f7 f0 ff ff       	jmp    8010546d <alltraps>
80106376:	66 90                	xchg   %ax,%ax
80106378:	66 90                	xchg   %ax,%ax
8010637a:	66 90                	xchg   %ax,%ax
8010637c:	66 90                	xchg   %ax,%ax
8010637e:	66 90                	xchg   %ax,%ax

80106380 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	57                   	push   %edi
80106384:	56                   	push   %esi
80106385:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106387:	c1 ea 16             	shr    $0x16,%edx
{
8010638a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010638b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010638e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106391:	8b 1f                	mov    (%edi),%ebx
80106393:	f6 c3 01             	test   $0x1,%bl
80106396:	74 28                	je     801063c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106398:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010639e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801063a4:	c1 ee 0a             	shr    $0xa,%esi
}
801063a7:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
801063aa:	89 f2                	mov    %esi,%edx
801063ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801063b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801063b5:	5b                   	pop    %ebx
801063b6:	5e                   	pop    %esi
801063b7:	5f                   	pop    %edi
801063b8:	5d                   	pop    %ebp
801063b9:	c3                   	ret    
801063ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801063c0:	85 c9                	test   %ecx,%ecx
801063c2:	74 34                	je     801063f8 <walkpgdir+0x78>
801063c4:	e8 c7 c0 ff ff       	call   80102490 <kalloc>
801063c9:	85 c0                	test   %eax,%eax
801063cb:	89 c3                	mov    %eax,%ebx
801063cd:	74 29                	je     801063f8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
801063cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801063d6:	00 
801063d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801063de:	00 
801063df:	89 04 24             	mov    %eax,(%esp)
801063e2:	e8 c9 de ff ff       	call   801042b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801063e7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801063ed:	83 c8 07             	or     $0x7,%eax
801063f0:	89 07                	mov    %eax,(%edi)
801063f2:	eb b0                	jmp    801063a4 <walkpgdir+0x24>
801063f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801063f8:	83 c4 1c             	add    $0x1c,%esp
      return 0;
801063fb:	31 c0                	xor    %eax,%eax
}
801063fd:	5b                   	pop    %ebx
801063fe:	5e                   	pop    %esi
801063ff:	5f                   	pop    %edi
80106400:	5d                   	pop    %ebp
80106401:	c3                   	ret    
80106402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106410 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	57                   	push   %edi
80106414:	89 c7                	mov    %eax,%edi
80106416:	56                   	push   %esi
80106417:	89 d6                	mov    %edx,%esi
80106419:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010641a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106420:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106423:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106429:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010642b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010642e:	72 3b                	jb     8010646b <deallocuvm.part.0+0x5b>
80106430:	eb 5e                	jmp    80106490 <deallocuvm.part.0+0x80>
80106432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106438:	8b 10                	mov    (%eax),%edx
8010643a:	f6 c2 01             	test   $0x1,%dl
8010643d:	74 22                	je     80106461 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010643f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106445:	74 54                	je     8010649b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106447:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010644d:	89 14 24             	mov    %edx,(%esp)
80106450:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106453:	e8 88 be ff ff       	call   801022e0 <kfree>
      *pte = 0;
80106458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010645b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106461:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106467:	39 f3                	cmp    %esi,%ebx
80106469:	73 25                	jae    80106490 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010646b:	31 c9                	xor    %ecx,%ecx
8010646d:	89 da                	mov    %ebx,%edx
8010646f:	89 f8                	mov    %edi,%eax
80106471:	e8 0a ff ff ff       	call   80106380 <walkpgdir>
    if(!pte)
80106476:	85 c0                	test   %eax,%eax
80106478:	75 be                	jne    80106438 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010647a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106480:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106486:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010648c:	39 f3                	cmp    %esi,%ebx
8010648e:	72 db                	jb     8010646b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106490:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106493:	83 c4 1c             	add    $0x1c,%esp
80106496:	5b                   	pop    %ebx
80106497:	5e                   	pop    %esi
80106498:	5f                   	pop    %edi
80106499:	5d                   	pop    %ebp
8010649a:	c3                   	ret    
        panic("kfree");
8010649b:	c7 04 24 86 70 10 80 	movl   $0x80107086,(%esp)
801064a2:	e8 b9 9e ff ff       	call   80100360 <panic>
801064a7:	89 f6                	mov    %esi,%esi
801064a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064b0 <seginit>:
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801064b6:	e8 b5 d1 ff ff       	call   80103670 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064bb:	31 c9                	xor    %ecx,%ecx
801064bd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
801064c2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801064c8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064cd:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064d1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
801064d6:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064d9:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064dd:	31 c9                	xor    %ecx,%ecx
801064df:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064e3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064e8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064ec:	31 c9                	xor    %ecx,%ecx
801064ee:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064f2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064f7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064fb:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064fd:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106501:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106505:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106509:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010650d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106511:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106515:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106519:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010651d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106521:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106526:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010652a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010652e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106532:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106536:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010653a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010653e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106542:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106546:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010654a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010654e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106552:	c1 e8 10             	shr    $0x10,%eax
80106555:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106559:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010655c:	0f 01 10             	lgdtl  (%eax)
}
8010655f:	c9                   	leave  
80106560:	c3                   	ret    
80106561:	eb 0d                	jmp    80106570 <mappages>
80106563:	90                   	nop
80106564:	90                   	nop
80106565:	90                   	nop
80106566:	90                   	nop
80106567:	90                   	nop
80106568:	90                   	nop
80106569:	90                   	nop
8010656a:	90                   	nop
8010656b:	90                   	nop
8010656c:	90                   	nop
8010656d:	90                   	nop
8010656e:	90                   	nop
8010656f:	90                   	nop

80106570 <mappages>:
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	57                   	push   %edi
80106574:	56                   	push   %esi
80106575:	53                   	push   %ebx
80106576:	83 ec 1c             	sub    $0x1c,%esp
80106579:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010657c:	8b 55 10             	mov    0x10(%ebp),%edx
{
8010657f:	8b 7d 14             	mov    0x14(%ebp),%edi
    *pte = pa | perm | PTE_P;
80106582:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
80106586:	89 c3                	mov    %eax,%ebx
80106588:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010658e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106592:	29 df                	sub    %ebx,%edi
80106594:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106597:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
8010659e:	eb 15                	jmp    801065b5 <mappages+0x45>
    if(*pte & PTE_P)
801065a0:	f6 00 01             	testb  $0x1,(%eax)
801065a3:	75 3d                	jne    801065e2 <mappages+0x72>
    *pte = pa | perm | PTE_P;
801065a5:	0b 75 18             	or     0x18(%ebp),%esi
    if(a == last)
801065a8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801065ab:	89 30                	mov    %esi,(%eax)
    if(a == last)
801065ad:	74 29                	je     801065d8 <mappages+0x68>
    a += PGSIZE;
801065af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801065b5:	8b 45 08             	mov    0x8(%ebp),%eax
801065b8:	b9 01 00 00 00       	mov    $0x1,%ecx
801065bd:	89 da                	mov    %ebx,%edx
801065bf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801065c2:	e8 b9 fd ff ff       	call   80106380 <walkpgdir>
801065c7:	85 c0                	test   %eax,%eax
801065c9:	75 d5                	jne    801065a0 <mappages+0x30>
}
801065cb:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801065ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065d3:	5b                   	pop    %ebx
801065d4:	5e                   	pop    %esi
801065d5:	5f                   	pop    %edi
801065d6:	5d                   	pop    %ebp
801065d7:	c3                   	ret    
801065d8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801065db:	31 c0                	xor    %eax,%eax
}
801065dd:	5b                   	pop    %ebx
801065de:	5e                   	pop    %esi
801065df:	5f                   	pop    %edi
801065e0:	5d                   	pop    %ebp
801065e1:	c3                   	ret    
      panic("remap");
801065e2:	c7 04 24 f0 76 10 80 	movl   $0x801076f0,(%esp)
801065e9:	e8 72 9d ff ff       	call   80100360 <panic>
801065ee:	66 90                	xchg   %ax,%ax

801065f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065f0:	a1 a4 56 11 80       	mov    0x801156a4,%eax
{
801065f5:	55                   	push   %ebp
801065f6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065f8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065fd:	0f 22 d8             	mov    %eax,%cr3
}
80106600:	5d                   	pop    %ebp
80106601:	c3                   	ret    
80106602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106610 <switchuvm>:
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	57                   	push   %edi
80106614:	56                   	push   %esi
80106615:	53                   	push   %ebx
80106616:	83 ec 1c             	sub    $0x1c,%esp
80106619:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010661c:	85 f6                	test   %esi,%esi
8010661e:	0f 84 cd 00 00 00    	je     801066f1 <switchuvm+0xe1>
  if(p->kstack == 0)
80106624:	8b 46 10             	mov    0x10(%esi),%eax
80106627:	85 c0                	test   %eax,%eax
80106629:	0f 84 da 00 00 00    	je     80106709 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010662f:	8b 7e 0c             	mov    0xc(%esi),%edi
80106632:	85 ff                	test   %edi,%edi
80106634:	0f 84 c3 00 00 00    	je     801066fd <switchuvm+0xed>
  pushcli();
8010663a:	e8 f1 da ff ff       	call   80104130 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010663f:	e8 ac cf ff ff       	call   801035f0 <mycpu>
80106644:	89 c3                	mov    %eax,%ebx
80106646:	e8 a5 cf ff ff       	call   801035f0 <mycpu>
8010664b:	89 c7                	mov    %eax,%edi
8010664d:	e8 9e cf ff ff       	call   801035f0 <mycpu>
80106652:	83 c7 08             	add    $0x8,%edi
80106655:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106658:	e8 93 cf ff ff       	call   801035f0 <mycpu>
8010665d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106660:	ba 67 00 00 00       	mov    $0x67,%edx
80106665:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010666c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106673:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010667a:	83 c1 08             	add    $0x8,%ecx
8010667d:	c1 e9 10             	shr    $0x10,%ecx
80106680:	83 c0 08             	add    $0x8,%eax
80106683:	c1 e8 18             	shr    $0x18,%eax
80106686:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010668c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106693:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106699:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010669e:	e8 4d cf ff ff       	call   801035f0 <mycpu>
801066a3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801066aa:	e8 41 cf ff ff       	call   801035f0 <mycpu>
801066af:	b9 10 00 00 00       	mov    $0x10,%ecx
801066b4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801066b8:	e8 33 cf ff ff       	call   801035f0 <mycpu>
801066bd:	8b 56 10             	mov    0x10(%esi),%edx
801066c0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801066c6:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801066c9:	e8 22 cf ff ff       	call   801035f0 <mycpu>
801066ce:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801066d2:	b8 28 00 00 00       	mov    $0x28,%eax
801066d7:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801066da:	8b 46 0c             	mov    0xc(%esi),%eax
801066dd:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801066e2:	0f 22 d8             	mov    %eax,%cr3
}
801066e5:	83 c4 1c             	add    $0x1c,%esp
801066e8:	5b                   	pop    %ebx
801066e9:	5e                   	pop    %esi
801066ea:	5f                   	pop    %edi
801066eb:	5d                   	pop    %ebp
  popcli();
801066ec:	e9 ff da ff ff       	jmp    801041f0 <popcli>
    panic("switchuvm: no process");
801066f1:	c7 04 24 f6 76 10 80 	movl   $0x801076f6,(%esp)
801066f8:	e8 63 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
801066fd:	c7 04 24 21 77 10 80 	movl   $0x80107721,(%esp)
80106704:	e8 57 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106709:	c7 04 24 0c 77 10 80 	movl   $0x8010770c,(%esp)
80106710:	e8 4b 9c ff ff       	call   80100360 <panic>
80106715:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106720 <inituvm>:
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	57                   	push   %edi
80106724:	56                   	push   %esi
80106725:	53                   	push   %ebx
80106726:	83 ec 2c             	sub    $0x2c,%esp
80106729:	8b 75 10             	mov    0x10(%ebp),%esi
8010672c:	8b 55 08             	mov    0x8(%ebp),%edx
8010672f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106732:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106738:	77 64                	ja     8010679e <inituvm+0x7e>
8010673a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
8010673d:	e8 4e bd ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
80106742:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106749:	00 
8010674a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106751:	00 
80106752:	89 04 24             	mov    %eax,(%esp)
  mem = kalloc();
80106755:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106757:	e8 54 db ff ff       	call   801042b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010675c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010675f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106765:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010676c:	00 
8010676d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106771:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106778:	00 
80106779:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106780:	00 
80106781:	89 14 24             	mov    %edx,(%esp)
80106784:	e8 e7 fd ff ff       	call   80106570 <mappages>
  memmove(mem, init, sz);
80106789:	89 75 10             	mov    %esi,0x10(%ebp)
8010678c:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010678f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106792:	83 c4 2c             	add    $0x2c,%esp
80106795:	5b                   	pop    %ebx
80106796:	5e                   	pop    %esi
80106797:	5f                   	pop    %edi
80106798:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106799:	e9 b2 db ff ff       	jmp    80104350 <memmove>
    panic("inituvm: more than a page");
8010679e:	c7 04 24 35 77 10 80 	movl   $0x80107735,(%esp)
801067a5:	e8 b6 9b ff ff       	call   80100360 <panic>
801067aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067b0 <loaduvm>:
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	56                   	push   %esi
801067b5:	53                   	push   %ebx
801067b6:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
801067b9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801067c0:	0f 85 98 00 00 00    	jne    8010685e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
801067c6:	8b 75 18             	mov    0x18(%ebp),%esi
801067c9:	31 db                	xor    %ebx,%ebx
801067cb:	85 f6                	test   %esi,%esi
801067cd:	75 1a                	jne    801067e9 <loaduvm+0x39>
801067cf:	eb 77                	jmp    80106848 <loaduvm+0x98>
801067d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067de:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801067e4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801067e7:	76 5f                	jbe    80106848 <loaduvm+0x98>
801067e9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801067ec:	31 c9                	xor    %ecx,%ecx
801067ee:	8b 45 08             	mov    0x8(%ebp),%eax
801067f1:	01 da                	add    %ebx,%edx
801067f3:	e8 88 fb ff ff       	call   80106380 <walkpgdir>
801067f8:	85 c0                	test   %eax,%eax
801067fa:	74 56                	je     80106852 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
801067fc:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
801067fe:	bf 00 10 00 00       	mov    $0x1000,%edi
80106803:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106806:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
8010680b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106811:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106814:	05 00 00 00 80       	add    $0x80000000,%eax
80106819:	89 44 24 04          	mov    %eax,0x4(%esp)
8010681d:	8b 45 10             	mov    0x10(%ebp),%eax
80106820:	01 d9                	add    %ebx,%ecx
80106822:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106826:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010682a:	89 04 24             	mov    %eax,(%esp)
8010682d:	e8 1e b1 ff ff       	call   80101950 <readi>
80106832:	39 f8                	cmp    %edi,%eax
80106834:	74 a2                	je     801067d8 <loaduvm+0x28>
}
80106836:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010683e:	5b                   	pop    %ebx
8010683f:	5e                   	pop    %esi
80106840:	5f                   	pop    %edi
80106841:	5d                   	pop    %ebp
80106842:	c3                   	ret    
80106843:	90                   	nop
80106844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106848:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010684b:	31 c0                	xor    %eax,%eax
}
8010684d:	5b                   	pop    %ebx
8010684e:	5e                   	pop    %esi
8010684f:	5f                   	pop    %edi
80106850:	5d                   	pop    %ebp
80106851:	c3                   	ret    
      panic("loaduvm: address should exist");
80106852:	c7 04 24 4f 77 10 80 	movl   $0x8010774f,(%esp)
80106859:	e8 02 9b ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
8010685e:	c7 04 24 14 78 10 80 	movl   $0x80107814,(%esp)
80106865:	e8 f6 9a ff ff       	call   80100360 <panic>
8010686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106870 <allocuvm>:
{
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	57                   	push   %edi
80106874:	56                   	push   %esi
80106875:	53                   	push   %ebx
80106876:	83 ec 2c             	sub    $0x2c,%esp
80106879:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010687c:	85 ff                	test   %edi,%edi
8010687e:	0f 88 8f 00 00 00    	js     80106913 <allocuvm+0xa3>
  if(newsz < oldsz)
80106884:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106887:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
8010688a:	0f 82 85 00 00 00    	jb     80106915 <allocuvm+0xa5>
  a = PGROUNDUP(oldsz);
80106890:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106896:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010689c:	39 df                	cmp    %ebx,%edi
8010689e:	77 57                	ja     801068f7 <allocuvm+0x87>
801068a0:	eb 7e                	jmp    80106920 <allocuvm+0xb0>
801068a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801068a8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068af:	00 
801068b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068b7:	00 
801068b8:	89 04 24             	mov    %eax,(%esp)
801068bb:	e8 f0 d9 ff ff       	call   801042b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801068c0:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801068c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
801068ca:	8b 45 08             	mov    0x8(%ebp),%eax
801068cd:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801068d4:	00 
801068d5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068dc:	00 
801068dd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801068e1:	89 04 24             	mov    %eax,(%esp)
801068e4:	e8 87 fc ff ff       	call   80106570 <mappages>
801068e9:	85 c0                	test   %eax,%eax
801068eb:	78 43                	js     80106930 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801068ed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068f3:	39 df                	cmp    %ebx,%edi
801068f5:	76 29                	jbe    80106920 <allocuvm+0xb0>
    mem = kalloc();
801068f7:	e8 94 bb ff ff       	call   80102490 <kalloc>
    if(mem == 0){
801068fc:	85 c0                	test   %eax,%eax
    mem = kalloc();
801068fe:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106900:	75 a6                	jne    801068a8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106902:	c7 04 24 6d 77 10 80 	movl   $0x8010776d,(%esp)
80106909:	e8 42 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010690e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106911:	77 47                	ja     8010695a <allocuvm+0xea>
      return 0;
80106913:	31 c0                	xor    %eax,%eax
}
80106915:	83 c4 2c             	add    $0x2c,%esp
80106918:	5b                   	pop    %ebx
80106919:	5e                   	pop    %esi
8010691a:	5f                   	pop    %edi
8010691b:	5d                   	pop    %ebp
8010691c:	c3                   	ret    
8010691d:	8d 76 00             	lea    0x0(%esi),%esi
80106920:	83 c4 2c             	add    $0x2c,%esp
80106923:	89 f8                	mov    %edi,%eax
80106925:	5b                   	pop    %ebx
80106926:	5e                   	pop    %esi
80106927:	5f                   	pop    %edi
80106928:	5d                   	pop    %ebp
80106929:	c3                   	ret    
8010692a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106930:	c7 04 24 85 77 10 80 	movl   $0x80107785,(%esp)
80106937:	e8 14 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010693c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010693f:	76 0d                	jbe    8010694e <allocuvm+0xde>
80106941:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106944:	89 fa                	mov    %edi,%edx
80106946:	8b 45 08             	mov    0x8(%ebp),%eax
80106949:	e8 c2 fa ff ff       	call   80106410 <deallocuvm.part.0>
      kfree(mem);
8010694e:	89 34 24             	mov    %esi,(%esp)
80106951:	e8 8a b9 ff ff       	call   801022e0 <kfree>
      return 0;
80106956:	31 c0                	xor    %eax,%eax
80106958:	eb bb                	jmp    80106915 <allocuvm+0xa5>
8010695a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010695d:	89 fa                	mov    %edi,%edx
8010695f:	8b 45 08             	mov    0x8(%ebp),%eax
80106962:	e8 a9 fa ff ff       	call   80106410 <deallocuvm.part.0>
      return 0;
80106967:	31 c0                	xor    %eax,%eax
80106969:	eb aa                	jmp    80106915 <allocuvm+0xa5>
8010696b:	90                   	nop
8010696c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106970 <deallocuvm>:
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	8b 55 0c             	mov    0xc(%ebp),%edx
80106976:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106979:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010697c:	39 d1                	cmp    %edx,%ecx
8010697e:	73 08                	jae    80106988 <deallocuvm+0x18>
}
80106980:	5d                   	pop    %ebp
80106981:	e9 8a fa ff ff       	jmp    80106410 <deallocuvm.part.0>
80106986:	66 90                	xchg   %ax,%ax
80106988:	89 d0                	mov    %edx,%eax
8010698a:	5d                   	pop    %ebp
8010698b:	c3                   	ret    
8010698c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106990 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	56                   	push   %esi
80106994:	53                   	push   %ebx
80106995:	83 ec 10             	sub    $0x10,%esp
80106998:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010699b:	85 f6                	test   %esi,%esi
8010699d:	74 59                	je     801069f8 <freevm+0x68>
8010699f:	31 c9                	xor    %ecx,%ecx
801069a1:	ba 00 00 00 80       	mov    $0x80000000,%edx
801069a6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801069a8:	31 db                	xor    %ebx,%ebx
801069aa:	e8 61 fa ff ff       	call   80106410 <deallocuvm.part.0>
801069af:	eb 12                	jmp    801069c3 <freevm+0x33>
801069b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069b8:	83 c3 01             	add    $0x1,%ebx
801069bb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801069c1:	74 27                	je     801069ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801069c3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
801069c6:	f6 c2 01             	test   $0x1,%dl
801069c9:	74 ed                	je     801069b8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801069cb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
801069d1:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801069d4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801069da:	89 14 24             	mov    %edx,(%esp)
801069dd:	e8 fe b8 ff ff       	call   801022e0 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
801069e2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801069e8:	75 d9                	jne    801069c3 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
801069ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801069ed:	83 c4 10             	add    $0x10,%esp
801069f0:	5b                   	pop    %ebx
801069f1:	5e                   	pop    %esi
801069f2:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801069f3:	e9 e8 b8 ff ff       	jmp    801022e0 <kfree>
    panic("freevm: no pgdir");
801069f8:	c7 04 24 a1 77 10 80 	movl   $0x801077a1,(%esp)
801069ff:	e8 5c 99 ff ff       	call   80100360 <panic>
80106a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a10 <setupkvm>:
{
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	56                   	push   %esi
80106a14:	53                   	push   %ebx
80106a15:	83 ec 20             	sub    $0x20,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106a18:	e8 73 ba ff ff       	call   80102490 <kalloc>
80106a1d:	85 c0                	test   %eax,%eax
80106a1f:	89 c6                	mov    %eax,%esi
80106a21:	74 75                	je     80106a98 <setupkvm+0x88>
  memset(pgdir, 0, PGSIZE);
80106a23:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a2a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a2b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106a30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a37:	00 
80106a38:	89 04 24             	mov    %eax,(%esp)
80106a3b:	e8 70 d8 ff ff       	call   801042b0 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106a40:	8b 53 0c             	mov    0xc(%ebx),%edx
80106a43:	8b 43 04             	mov    0x4(%ebx),%eax
80106a46:	89 34 24             	mov    %esi,(%esp)
80106a49:	89 54 24 10          	mov    %edx,0x10(%esp)
80106a4d:	8b 53 08             	mov    0x8(%ebx),%edx
80106a50:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106a54:	29 c2                	sub    %eax,%edx
80106a56:	8b 03                	mov    (%ebx),%eax
80106a58:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a60:	e8 0b fb ff ff       	call   80106570 <mappages>
80106a65:	85 c0                	test   %eax,%eax
80106a67:	78 17                	js     80106a80 <setupkvm+0x70>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a69:	83 c3 10             	add    $0x10,%ebx
80106a6c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106a72:	72 cc                	jb     80106a40 <setupkvm+0x30>
80106a74:	89 f0                	mov    %esi,%eax
}
80106a76:	83 c4 20             	add    $0x20,%esp
80106a79:	5b                   	pop    %ebx
80106a7a:	5e                   	pop    %esi
80106a7b:	5d                   	pop    %ebp
80106a7c:	c3                   	ret    
80106a7d:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
80106a80:	89 34 24             	mov    %esi,(%esp)
80106a83:	e8 08 ff ff ff       	call   80106990 <freevm>
}
80106a88:	83 c4 20             	add    $0x20,%esp
      return 0;
80106a8b:	31 c0                	xor    %eax,%eax
}
80106a8d:	5b                   	pop    %ebx
80106a8e:	5e                   	pop    %esi
80106a8f:	5d                   	pop    %ebp
80106a90:	c3                   	ret    
80106a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106a98:	31 c0                	xor    %eax,%eax
80106a9a:	eb da                	jmp    80106a76 <setupkvm+0x66>
80106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <kvmalloc>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106aa6:	e8 65 ff ff ff       	call   80106a10 <setupkvm>
80106aab:	a3 a4 56 11 80       	mov    %eax,0x801156a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ab0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ab5:	0f 22 d8             	mov    %eax,%cr3
}
80106ab8:	c9                   	leave  
80106ab9:	c3                   	ret    
80106aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ac0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ac0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ac1:	31 c9                	xor    %ecx,%ecx
{
80106ac3:	89 e5                	mov    %esp,%ebp
80106ac5:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106acb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ace:	e8 ad f8 ff ff       	call   80106380 <walkpgdir>
  if(pte == 0)
80106ad3:	85 c0                	test   %eax,%eax
80106ad5:	74 05                	je     80106adc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ad7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106ada:	c9                   	leave  
80106adb:	c3                   	ret    
    panic("clearpteu");
80106adc:	c7 04 24 b2 77 10 80 	movl   $0x801077b2,(%esp)
80106ae3:	e8 78 98 ff ff       	call   80100360 <panic>
80106ae8:	90                   	nop
80106ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106af0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint sm, uint spgcount)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
80106af6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106af9:	e8 12 ff ff ff       	call   80106a10 <setupkvm>
80106afe:	85 c0                	test   %eax,%eax
80106b00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b03:	0f 84 86 01 00 00    	je     80106c8f <copyuvm+0x19f>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b09:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b0c:	85 c0                	test   %eax,%eax
80106b0e:	0f 84 ac 00 00 00    	je     80106bc0 <copyuvm+0xd0>
80106b14:	31 db                	xor    %ebx,%ebx
80106b16:	eb 51                	jmp    80106b69 <copyuvm+0x79>
      panic("copyuvm(sz): page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106b18:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106b1e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b25:	00 
80106b26:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106b2a:	89 04 24             	mov    %eax,(%esp)
80106b2d:	e8 1e d8 ff ff       	call   80104350 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b35:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106b3b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106b3f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b46:	00 
80106b47:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106b4b:	89 44 24 10          	mov    %eax,0x10(%esp)
80106b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b52:	89 04 24             	mov    %eax,(%esp)
80106b55:	e8 16 fa ff ff       	call   80106570 <mappages>
80106b5a:	85 c0                	test   %eax,%eax
80106b5c:	78 4d                	js     80106bab <copyuvm+0xbb>
  for(i = 0; i < sz; i += PGSIZE){
80106b5e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b64:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106b67:	76 57                	jbe    80106bc0 <copyuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b69:	8b 45 08             	mov    0x8(%ebp),%eax
80106b6c:	31 c9                	xor    %ecx,%ecx
80106b6e:	89 da                	mov    %ebx,%edx
80106b70:	e8 0b f8 ff ff       	call   80106380 <walkpgdir>
80106b75:	85 c0                	test   %eax,%eax
80106b77:	0f 84 19 01 00 00    	je     80106c96 <copyuvm+0x1a6>
    if(!(*pte & PTE_P))
80106b7d:	8b 30                	mov    (%eax),%esi
80106b7f:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106b85:	0f 84 17 01 00 00    	je     80106ca2 <copyuvm+0x1b2>
    pa = PTE_ADDR(*pte);
80106b8b:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106b8d:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106b93:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106b96:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106b9c:	e8 ef b8 ff ff       	call   80102490 <kalloc>
80106ba1:	85 c0                	test   %eax,%eax
80106ba3:	89 c6                	mov    %eax,%esi
80106ba5:	0f 85 6d ff ff ff    	jne    80106b18 <copyuvm+0x28>
  
  
  return d;

bad:
  freevm(d);
80106bab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bae:	89 04 24             	mov    %eax,(%esp)
80106bb1:	e8 da fd ff ff       	call   80106990 <freevm>
  return 0;
80106bb6:	31 c0                	xor    %eax,%eax
}
80106bb8:	83 c4 2c             	add    $0x2c,%esp
80106bbb:	5b                   	pop    %ebx
80106bbc:	5e                   	pop    %esi
80106bbd:	5f                   	pop    %edi
80106bbe:	5d                   	pop    %ebp
80106bbf:	c3                   	ret    
 for(i = PGROUNDUP(sm - (spgcount * PGSIZE)); i < PGROUNDUP(sm); i += PGSIZE){
80106bc0:	8b 45 10             	mov    0x10(%ebp),%eax
80106bc3:	8b 55 14             	mov    0x14(%ebp),%edx
80106bc6:	05 ff 0f 00 00       	add    $0xfff,%eax
80106bcb:	c1 e2 0c             	shl    $0xc,%edx
80106bce:	89 c3                	mov    %eax,%ebx
80106bd0:	29 d3                	sub    %edx,%ebx
80106bd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bd7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106bdd:	39 c3                	cmp    %eax,%ebx
80106bdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106be2:	72 61                	jb     80106c45 <copyuvm+0x155>
80106be4:	e9 9b 00 00 00       	jmp    80106c84 <copyuvm+0x194>
80106be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
   memmove(mem, (char*)P2V(pa), PGSIZE);
80106bf0:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106bf6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bfd:	00 
80106bfe:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106c02:	89 04 24             	mov    %eax,(%esp)
80106c05:	e8 46 d7 ff ff       	call   80104350 <memmove>
   if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0){
80106c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c0d:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106c13:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106c17:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c1e:	00 
80106c1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106c23:	89 44 24 10          	mov    %eax,0x10(%esp)
80106c27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c2a:	89 04 24             	mov    %eax,(%esp)
80106c2d:	e8 3e f9 ff ff       	call   80106570 <mappages>
80106c32:	85 c0                	test   %eax,%eax
80106c34:	0f 88 71 ff ff ff    	js     80106bab <copyuvm+0xbb>
 for(i = PGROUNDUP(sm - (spgcount * PGSIZE)); i < PGROUNDUP(sm); i += PGSIZE){
80106c3a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c40:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106c43:	73 3f                	jae    80106c84 <copyuvm+0x194>
   if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0){
80106c45:	8b 45 08             	mov    0x8(%ebp),%eax
80106c48:	31 c9                	xor    %ecx,%ecx
80106c4a:	89 da                	mov    %ebx,%edx
80106c4c:	e8 2f f7 ff ff       	call   80106380 <walkpgdir>
80106c51:	85 c0                	test   %eax,%eax
80106c53:	74 41                	je     80106c96 <copyuvm+0x1a6>
   if(!(*pte & PTE_P)){
80106c55:	8b 30                	mov    (%eax),%esi
80106c57:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106c5d:	74 4f                	je     80106cae <copyuvm+0x1be>
   pa = PTE_ADDR(*pte);	
80106c5f:	89 f7                	mov    %esi,%edi
   flags = PTE_FLAGS(*pte);
80106c61:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106c67:	89 75 e4             	mov    %esi,-0x1c(%ebp)
   pa = PTE_ADDR(*pte);	
80106c6a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
   if((mem = kalloc()) == 0){
80106c70:	e8 1b b8 ff ff       	call   80102490 <kalloc>
80106c75:	85 c0                	test   %eax,%eax
80106c77:	89 c6                	mov    %eax,%esi
80106c79:	0f 85 71 ff ff ff    	jne    80106bf0 <copyuvm+0x100>
80106c7f:	e9 27 ff ff ff       	jmp    80106bab <copyuvm+0xbb>
80106c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80106c87:	83 c4 2c             	add    $0x2c,%esp
80106c8a:	5b                   	pop    %ebx
80106c8b:	5e                   	pop    %esi
80106c8c:	5f                   	pop    %edi
80106c8d:	5d                   	pop    %ebp
80106c8e:	c3                   	ret    
    return 0;
80106c8f:	31 c0                	xor    %eax,%eax
80106c91:	e9 22 ff ff ff       	jmp    80106bb8 <copyuvm+0xc8>
      panic("copyuvm: pte should exist");
80106c96:	c7 04 24 bc 77 10 80 	movl   $0x801077bc,(%esp)
80106c9d:	e8 be 96 ff ff       	call   80100360 <panic>
      panic("copyuvm(sz): page not present");
80106ca2:	c7 04 24 d6 77 10 80 	movl   $0x801077d6,(%esp)
80106ca9:	e8 b2 96 ff ff       	call   80100360 <panic>
	panic("copyuvm(sm): page not present");
80106cae:	c7 04 24 f4 77 10 80 	movl   $0x801077f4,(%esp)
80106cb5:	e8 a6 96 ff ff       	call   80100360 <panic>
80106cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cc0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106cc0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106cc1:	31 c9                	xor    %ecx,%ecx
{
80106cc3:	89 e5                	mov    %esp,%ebp
80106cc5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cce:	e8 ad f6 ff ff       	call   80106380 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106cd3:	8b 00                	mov    (%eax),%eax
80106cd5:	89 c2                	mov    %eax,%edx
80106cd7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106cda:	83 fa 05             	cmp    $0x5,%edx
80106cdd:	75 11                	jne    80106cf0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106cdf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ce4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106ce9:	c9                   	leave  
80106cea:	c3                   	ret    
80106ceb:	90                   	nop
80106cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106cf0:	31 c0                	xor    %eax,%eax
}
80106cf2:	c9                   	leave  
80106cf3:	c3                   	ret    
80106cf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 1c             	sub    $0x1c,%esp
80106d09:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d12:	85 db                	test   %ebx,%ebx
80106d14:	75 3a                	jne    80106d50 <copyout+0x50>
80106d16:	eb 68                	jmp    80106d80 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d18:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d1b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d1d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106d21:	29 ca                	sub    %ecx,%edx
80106d23:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106d29:	39 da                	cmp    %ebx,%edx
80106d2b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106d2e:	29 f1                	sub    %esi,%ecx
80106d30:	01 c8                	add    %ecx,%eax
80106d32:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d36:	89 04 24             	mov    %eax,(%esp)
80106d39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106d3c:	e8 0f d6 ff ff       	call   80104350 <memmove>
    len -= n;
    buf += n;
80106d41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106d44:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106d4a:	01 d7                	add    %edx,%edi
  while(len > 0){
80106d4c:	29 d3                	sub    %edx,%ebx
80106d4e:	74 30                	je     80106d80 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106d50:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106d53:	89 ce                	mov    %ecx,%esi
80106d55:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106d5b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106d5f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106d62:	89 04 24             	mov    %eax,(%esp)
80106d65:	e8 56 ff ff ff       	call   80106cc0 <uva2ka>
    if(pa0 == 0)
80106d6a:	85 c0                	test   %eax,%eax
80106d6c:	75 aa                	jne    80106d18 <copyout+0x18>
  }
  return 0;
}
80106d6e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d76:	5b                   	pop    %ebx
80106d77:	5e                   	pop    %esi
80106d78:	5f                   	pop    %edi
80106d79:	5d                   	pop    %ebp
80106d7a:	c3                   	ret    
80106d7b:	90                   	nop
80106d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d80:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106d83:	31 c0                	xor    %eax,%eax
}
80106d85:	5b                   	pop    %ebx
80106d86:	5e                   	pop    %esi
80106d87:	5f                   	pop    %edi
80106d88:	5d                   	pop    %ebp
80106d89:	c3                   	ret    
80106d8a:	66 90                	xchg   %ax,%ax
80106d8c:	66 90                	xchg   %ax,%ax
80106d8e:	66 90                	xchg   %ax,%ax

80106d90 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106d96:	c7 44 24 04 38 78 10 	movl   $0x80107838,0x4(%esp)
80106d9d:	80 
80106d9e:	c7 04 24 c0 56 11 80 	movl   $0x801156c0,(%esp)
80106da5:	e8 d6 d2 ff ff       	call   80104080 <initlock>
  acquire(&(shm_table.lock));
80106daa:	c7 04 24 c0 56 11 80 	movl   $0x801156c0,(%esp)
80106db1:	e8 ba d3 ff ff       	call   80104170 <acquire>
80106db6:	b8 f4 56 11 80       	mov    $0x801156f4,%eax
80106dbb:	90                   	nop
80106dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106dc6:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80106dc9:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80106dd0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
80106dd7:	3d f4 59 11 80       	cmp    $0x801159f4,%eax
80106ddc:	75 e2                	jne    80106dc0 <shminit+0x30>
  }
  release(&(shm_table.lock));
80106dde:	c7 04 24 c0 56 11 80 	movl   $0x801156c0,(%esp)
80106de5:	e8 76 d4 ff ff       	call   80104260 <release>
}
80106dea:	c9                   	leave  
80106deb:	c3                   	ret    
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106df0 <shm_open>:

int shm_open(int id, char **pointer) {
80106df0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106df1:	31 c0                	xor    %eax,%eax
int shm_open(int id, char **pointer) {
80106df3:	89 e5                	mov    %esp,%ebp
}
80106df5:	5d                   	pop    %ebp
80106df6:	c3                   	ret    
80106df7:	89 f6                	mov    %esi,%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e00 <shm_close>:


int shm_close(int id) {
80106e00:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106e01:	31 c0                	xor    %eax,%eax
int shm_close(int id) {
80106e03:	89 e5                	mov    %esp,%ebp
}
80106e05:	5d                   	pop    %ebp
80106e06:	c3                   	ret    
