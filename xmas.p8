pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
deer = {51,52,54,53}
tree = {12,14}
santa = {1,2,3,4,5,6}
star = {44,46,45,47}
elf = {18,19,20,21,22,23}
elfcarry = {34,35,36}
treeidx = 1
rudidx = 1
santaidx = 1
elfidx = 1
iscarry=true
staridx = 1
rudtime = 0
treetime = 0
santatime = 0
elftime = 0
onfloor = 80

function _init()
  music(0)
  snow={}
  deers={}
  elves={}
  makedeer()
  makeelves()
  makesnow(0,0,128,112,256)
  
end

function _update60()
  treetime += 1
  rudtime += 1
  santatime += 1
  if(treetime > 12) treeidx += 1 treetime = 0
  if(santatime > 6) staridx += 1 santaidx += 1 santatime = 0
  if(treeidx > 2) treeidx = 1
  if(santaidx > #santa) santaidx = 1
  if(staridx > #star) staridx = 1
  update_elves()
  update_deer()
  update_snow()
  kill_snow()
end

function _draw()
  rectfill(0,0,128,onfloor+8,13)
  map(0,0,0,onfloor + 8,16,2)
  palt(13, true)
  palt(0, false)
  spr(star[staridx], 109, onfloor - 44)
  draw_snow(1,128)
  -- happy xmas!
  spr(67, 28, onfloor - 40, 9, 4)
  
  -- presents and tree
  spr(62, 102, onfloor, 1, 1, true)
  spr(tree[treeidx], 96, onfloor - 8, 2, 2)
  spr(61, 80, onfloor, 2, 1)
  spr(62, 112, onfloor, 2, 1)
  spr(63, 94, onfloor, 1, 1)
  
  spr(60, 8, onfloor)
  draw_deer()
  draw_elves()
  draw_santa()
  drawsled()
  draw_snow(128,256)

  rectfill(0,0,128,20,0)
  rectfill(0,onfloor + 24,128,128,0)
  map(0,2,0,20,16,1)
  map(0,3,0,onfloor + 18,16,1)
end

function drawsled()
  spr(62, 5, onfloor - 2)
  spr(48, 0, onfloor, 3, 1)
end

function draw_deer()
  local x = 24
  for i=1, #deers, 1 do
	local d = deers[i]
	pal(11, d.n)
	spr(deer[d.f], x, onfloor)
	if(i<#deers) then spr(59,x,onfloor) end
	x += 8
  end
  pal(11, 11)
end

function draw_snow(start, count)
  for i=start, count, 1 do
   local p = snow[i]
   local px=0.5+p.x
   local py=0.5+p.y
    if p.snw==0 or p.snw==nil then
      pset(px,py,6)
    else
      spr(p.snw,px-1,py-1)
    end
  end
end

function draw_santa()
	spr(santa[santaidx], 72, onfloor, 1, 1)
end

function draw_elves()
  for e in all(elves) do
	if(e.c) then spr(elfcarry[e.f], e.x, e.y, 1, 1, e.m)
	else spr(elf[e.f], e.x, e.y,1 ,1, e.m) end
  end
end

function update_snow()
 for p in all(snow) do
  if p.grav then
   p.dy+=0.015
   p.dx*=0.995
  end
  p.x+=p.dx
  p.y+=p.dy
 end
end

function update_deer()
  for i=1, #deers, 1 do
    local d = deers[i]
	d.t += 1
	if(d.t > 24 and flr(rnd(32)) == 1) then d.f = 1+flr(rnd(4)) d.t = 0 end
  end
end

function update_elves()
  for e in all(elves) do
    e.t += 1
	if(e.t > 6) then 
	  e.f += 1 
	  e.t = 0 
	end
	
	if((e.c and e.f > 3) or (e.f > 6 and not e.c)) then e.f = 1 end
	
	if(e.x > 4 and e.x < 20) then 
	  e.y = onfloor-1
	else 
	  e.y = onfloor
	end
	
	if(e.x < 8 and not e.c) then 
	  e.c = true
	  e.m = false
	elseif(e.x > 92 and e.c) then 
	  e.c = false 
	  e.m = true 
	end
	
	if(e.m) then e.x -= .25
	else e.x += .25 end
  end
end

function kill_snow()
 for p in all(snow) do
  if p.x < -16 then
   del(snow,p)
  elseif p.snw > 0 and p.y >= onfloor + 3 then
	p.y -= 128
	p.x = flr(rnd(128))
  elseif p.y >= onfloor + 7 then
    p.y-=128
	p.x = flr(rnd(128))
  end
 end
end

function makesnow(x,y,w,h,n)
 local px,py,_snw
 for i=1,n do
  px=flr(x+rnd(w))
  py=flr(y+rnd(h))
  local tdy=0.2+rnd(0.45)
  if rnd(16)<1 then
   _snw=flr(16+(rnd(2)))
  else
   _snw=0
  end
  add(snow,{x=px,y=py,dx=0,dy=tdy,grav=false,snw=_snw})
 end
end

function makedeer()
  for i=1, 4, 1 do
	local d = { f=1+flr(rnd(4)), n=1, t=0}
	add(deers, d)
  end
  deers[4].n = 8
end

function makeelves()
  for i=1, 1, 1 do
    local e = {x=10, y=onfloor, t=11, b=3,c=true, f=1, t=0, m=false}
	add(elves, e)
  end
end

__gfx__
00000000dd7ddddddd7ddddddddddddddddddddddddddddddddddddd00000000dddddddd000000000000000000000000dddddddd7ddddddddddddddd7ddddddd
00000000ddd876ddddd876dddd7ddddddd7ddddddd7876dddd7876dd00000000dd0ddd0d000000000000000000000000dddddddaaaddddddddddddd7a7dddddd
00700700d217eeddd22865ddddd876ddddd876ddddd7eeddd217eedd0d000d00d0d0d0d0000000000000000000000000ddddddd9a9dddddddddddddaaadddddd
00077000214277dd2217eeddd217eeddd217eeddd24277dd214277dd000d000d0d0d0d0d000000000000000000000000dddddde3b33ddddddddddd83b33ddddd
000770001482674d214277dd214277dd214277dd2482764d1482674dd0d0d0d0d000d000000000000000000000000000dddddd3be38ddddddddddd3b83eddddd
007007001087090614876746148767461482674d1082090d1082090d0d0d0d0d00d000d0000000000000000000000000ddddd1133cd3ddddddddd1133d13dddd
00000000d448884dd000090d1080090d1087090614478846d4478846d0ddd0dd00000000000000000000000000000000dddd99bbbcc1dddddddd9abbbdd1dddd
00000000dd0dd0dd44888884d488884dd448884ddd0dd0dddd0dd0dddddddddd00000000000000000000000000000000dddd9a8339e33dddddddaae33a833ddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd00000000000000000000000000000000ddd3e139e3311dddddd3813983311ddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd00000000000000000000000000000000ddd1913333ef33ddddd1a13333ef33dd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd00000000000000000000000000000000ddd338abbbeebdddddd33e9bbbffbddd
ddd6ddddddd6d6dddd7ddddddddddddddddddddddd7ddddddddddddddddddddd00000000000000000000000000000000d33bfa398311833dd33b773ae311e33d
dd6d6ddddddd6ddddddbbddddd7bbddddd7bbddddddbbddddd7bbddddd7bbddd00000000000000000000000000000000dd13ff3b33ea3bb1dd13aa3b33893bb1
ddd6ddddddd6d6ddddfbfedddddbfddddddbfdddddebffdddddbfddddddbfddd00000000000000000000000000000000dd331133131111dddd331133131111dd
dddddddddddddddddd133ddddddf3dddddd3fddddd133dddddd3fddddddf3ddd00000000000000000000000000000000ddd111111111ddddddd111111111dddd
ddddddddddddddddddddd1dddddd1dddddd1ddddddddd1dddddd1dddddd1dddd00000000000000000000000000000000ddddddd422ddddddddddddd422dddddd
ddddddddddddddddddefeeddddefeeddddefeedd00000000000000007777777777777777000000000000000000000000dddd9dddddd9dddddddddddddddddddd
dddddddddddddddddd2e82dddd2e82dddd2e82dd00000000000000007777777777777777000000000000000000000000ddddaddddddadddddddd9dddddd9dddd
ddd6ddddd6dddddddd8e28dddd8e28dddd8e28dd00000000000000007777777777777777000000000000000000000000dddd7dddddd7ddddddddaddddddadddd
ddd7dddddddddddddd2e82dddd2e82dddd2e82dd00000000000000006777777777777777000000000000000000000000d9aa7dddddd7aa9d9a77adddddda7aa9
dd676ddddddd6dddddfbbeddddfbbeddddfbbedd0000000000000000cc77776c77777666000000000000000000000000ddd7aa9dd9aa7dddddda7aa99a77addd
ddd7dddddddddddddddbfddddddbfddddddbfddd00000000000000007776677766666ccc000000000000000000000000dddaddddddddaddddddaddddddddaddd
ddd6dddddddddddddd133dddddd33dddddd33ddd000000000000000066677777cc677776000000000000000000000000dddaddddddddadddddd9dddddddd9ddd
ddddddddddddddddddddd1dddddd1dddddd1dddd0000000000000000c766666c66666666000000000000000000000000ddd9dddddddd9ddddddddddddddddddd
dddddddddddddddddddddddddd25ddddddd25ddddddddddddd25dddd66666666666666666666666666666666dddddddddddddddddddddddddddddddddddddddd
ddddddddddddddddddd9dd4ddd1515ddddd1515ddd25dddddd1515dd66666666666666666666666666666666dddddddddddddddddddddddddd8d8ddddddddddd
dddd999997dddddddd9d74d4dd11244dddd1124ddd15144bdd11244d66666666666ddddd66666666ddddd666dddddddddd444dddddddddddd3b8bddddddddddd
dddd4888889ddddddd9ddeddddd9444bddd9444ddd11244dddd9444b66666ccccccccc66ccc6666666ccccccddddddddddd224ddddddddddd2888ddddddddddd
ddddd788e889ddddddd98e4dd4e4e9ddd4e4e44bd4e4e9ddd4e4e9dddddccdd6666666666ddccddd66666666dddddddddddd224dddd3d3ddd3b8b3d3ddefeedd
dddd988e8e89dddddddd78e44e9444dd4e9449dd4e9445dd4e94455dcccdddddddddcdc6dddddccc6cdcddddddddd8dddddd114ddd1c3cdd9ab81c3cdd2e82dd
dddd9888e8889ddddddd988ee45d45dde45d45dde45d45dde45d4d1d6cc6cccc66dd6666cccc6cc66666dd66dddddd88ddddd124dd3333dd8ee83333dd8e28dd
ddddd999999999999999224dd21d21ddd21d21ddd21d21ddd21d2ddd66666666666666666666666666666666dddddddddddddddddd1c3cdd8ee81c3cdd2e82dd
dddddddddddddddddddddddddddddddddddddddddddd8ddddddddd88dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddd88ddddddd888dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddd288dddddd882dddddd88ddddd8dddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddddddddddd888ddddddddd88ddddd882dddddd8228ddd828dddd88ddd888ddddddddddddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddddddddd888888dddd8ddd888ddd888ddddddd8dd8dd82d8dddd88ddd888ddddddddddddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddddddd888822288dd88dd8288ddd882ddd88dd8d82dd8dd8dddd88ddd882ddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddd88882ddd28dd888d8d88dd888ddd8828d882ddd8d82ddd882dd888dddddddddddddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddddd88882ddddd88d888d8d88d8888ddd88d8d8888dd882dddd88888288dddddddddddddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddddd8882dddddd28d828d8d88d8888ddd8882d8888dd2888ddd28882d88dddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddd8882dddddddd8d8d2d8d8882888ddd882d82288dd82888ddd822dd888ddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddd888ddd8888dd8d28dd8d888d2888dd88d82dd88dd8d888dd82dddd2888dddddddddddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddd8882ddd8882dd8dd8d88d882dd288dd2882ddd88d82d882dd8ddd88d288dddddddddddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddd888dddd888dd82dd8d82d88dddd888dd22dddd8882dd88dd82dd888dd88dddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddd8888dddd288dd8ddd282dd22888d2888ddddddd822ddd88882dd8828dd88dddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddd8882ddddd88888dddd2dddd88288d888ddddddd2d8ddd2222ddd82d2dd88dddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddd888dddddd228828dddddddd88d22d222d88888888888888ddddd8ddddd88ddddd8dddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddd888ddddddd882d8dddddddd8888888888222222288222288dddd88ddd882dddd888ddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddd888ddddddd88dd8dddddddd2888222222dddddd888ddd888dddd2888822dddd8882ddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddd888ddddddd88d88ddddd88dd22288dddddddddd888dd8882ddddd2222dddddd882dddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddd8888dddddd88d82dddd8228dddd888dddd88ddd882dd222ddddddddddddddd882ddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddd2888dddddd8882ddddd8dd8dddd288ddd8888dd88ddddddddddddddddddddd888ddddddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddd8888ddddd888d88ddd8dd8ddddd22dd88822dd88dddddddddddddd88ddddd8888dddddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddd28888dddd88888888d8dd8ddddd8ddd288dddd88dddd888d88dddd8888ddd88888ddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddd2228888888888288d888888ddd88dd8288ddd288ddd8828828dd882288dd828888dddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddddddd2222288882d88d2888888dd88dd8d888ddd88dd888d88d88d88dd88dd8d28888ddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddd8882dd88dd282888d888d82d2888dd88dd888d88d88d88dd88d82dd2888ddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddd888dd888dd82d882d8888288d2888d88dd888d28d88d28882882dddd288ddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddd888dd882dd8dd88d888228888d888d2888282dd2d28dd822d22888dd288ddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddd882dd288d82d888d822dd8822d888dd222d2dddddd2882dddd8882dd882ddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddd82dddd2882dd22882dddd28888882dddddddddddddd22ddddd822dd888dddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddd2dddddd22ddddd22dddddd288882dddddddddddddddddddddd28888822dddddddddddddddddddddddddddddddddddd
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddd2222dddddddddddddddddddddddd22222dddddddddddddddddddddddddddddddddddddd
__map__
2728282728272728282728272827282700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3738393a37393a383a3937393738393a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
012800000e5551755515555135550e555005000050000500005000050000500005000050000500005000050000500000000000000000000000000000000000000000000000000000000000000000000000000000
0130001f0c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c6110c611
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0130000031931319313193125931259312593118931189310c9311193111931119312193121931219312d9312d9312d9313793137931379312893128931289311c9311c9311c9311193111931119312193121931
__music__
03 0b424344

