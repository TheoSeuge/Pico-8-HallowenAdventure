pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--jeu d'aventure

function _init()
    scene = "menu"
    create_player()
    init_msg()
end 

function _update()
    if scene == "menu" then
        update_menu()
    elseif scene == "game" then
        update_game()
    end
end

function _draw()
    if scene == "menu" then
        draw_menu()
    elseif scene == "game" then
        draw_game()
    end
end

--UPDATE

function update_menu()
    if btnp(5) then
        scene = "game"
    end
end

function update_game()
    player_movement()
    update_camera()
    update_msg()
end

--DRAW

function draw_menu()
    cls()
    map(0, 49)
    print("PRESS 'X' TO", 38, 50, 9)
    print("TO START THE ADVENTURE GAME.", 10, 56, 9)
    spr(18, 28, 40)
end

function draw_game()
    cls()
    draw_map()
    draw_player()
    draw_ui()
    draw_msg()
end


function draw_ui()
    camera()
    palt(0, false)
    palt(3, true)
    
    spr(38, 2, 4)
    
    palt()
    print_outline("x"..p.candy, 10, 4)
end

function print_outline(text, x, y)
    print(text, x - 1, y, 0)
    print(text, x + 1, y, 0)
    print(text, x, y - 1, 0)    
    print(text, x, y + 1, 0)
    print(text, x, y, 7)
end

-->
--
-->

function create_player()
    p = {
		-- sprite and delay value
		sprite = 16, -- Sprite 
		delay = 4, -- Delay
		x = 3, -- coordinate x 
		y = 13, -- coordinate y 
		w = false,  -- to call walk function
        candy = 0
	}
end

function draw_player()
    spr(p.sprite, p.x * 8, p.y * 8)
end

-->
--
-->

function next_tile(x, y)
    sprite = mget(x, y)
    mset(x, y, sprite + 1)
end

function pick_up_candy(x, y)
    next_tile(x, y)
    p.candy += 1
    sfx(0)
end

function ghost_remove(x, y)
    next_tile(x, y)
    p.candy -= 1
    sfx(1)
end

--MOVEMENT

function interact(x, y)
    if check_flag(1, x, y) then
        pick_up_candy(x, y)
    elseif check_flag(2, x, y) and p.candy > 0 then
        ghost_remove(x, y)
    end
    if check_flag(2,x,y) then
  	    create_msg("fantome","bouh!","des bonbons ou un sort!")
    end   
end

function player_movement()
    p.w = false 
	newx = p.x
	newy = p.y

    if btnp(0) then 
        newx -= 1
        p.w = true
    end 
    if btnp(1) then 
        newx += 1 
        p.w = true
    end 

    if btnp(2) then 
        newy -= 1
        p.w = true
    end 

    if btnp(3) then 
        newy += 1
        p.w = true
    end

    if p.w then walk() 
    else 
        p.sprite = 16
    end 

    interact(newx, newy)

	if not check_flag(0, newx, newy) then
		p.x = mid (0, newx, 127)
		p.y = mid (0, newy, 63)
	end
end

function walk()
    p.delay = p.delay-1
    if (p.delay<0) then 
        p.sprite = p.sprite+1
        if (p.sprite > 18) then p.sprite = 16 end 
        p.delay = 4
    end
end 

function check_flag(flag, x, y)
	local sprite = mget(x, y)
	return fget(sprite, flag)
end

--CAMERA

function update_camera()
    camx = flr (p.x / 16) * 16
    camy = flr (p.y / 16) * 16
    camera(camx * 8, camy * 8)
end

function draw_map()
    map(0, 0, 0, 0, 128, 64)
end

--DIALOGUE
function init_msg()
	messages={}
end

function create_msg(name,...)
	msg_title=name
	messages={...}
end

function update_msg()
	if btnp(❎) then
	 deli(messages,1)
	end
end

function draw_msg()
	if messages[1] then
		local y=100
		if p.y%16>9 then
			y=10
		end
		rectfill(6,y,6+#msg_title*4,y+6,2)
		print (msg_title,7,y,7)
		rectfill(2,y+9,125,y+20,4)
		print(messages[1],0,y+10,7)
	end
end

__gfx__
000000003333333333933333333333333333333333bbbb331111111144444444334f44333333333333333333334444333333333333444433bb3bb33333333333
000000003333333339a9339333333833337333333bbabab311111111cccccccc33444533333333333333333333445433333333333344f4333b3b333b33033333
0070070033333333339339a933338a8337a733333b3aa3b311111111111111113354443354444454334f44444f444433444444333344444433333bb330903333
00077000333333333333339333333833337333333ba33b0311111111111111113344f4334f44f44f334444f44444443345444f333345444fb3333b3333033333
00077000333333333933333333833333333337333b3b3003111111111111111133444533445444443344544444f4443344444433334445443bb3b33b33333533
00700700333333339a93393338a8333333337a7333b3b033111111111111111133f444334444f445334444444444453344444533334444443b33b33333335953
000000003333333339339a93338333333333373333344333111111111111111133445433333333333345443333333333334f4433333333333b3b333333333533
00000000333333333333393333333333333333333344043311111111111111113344443333333333334444333333333333444433333333333b333bbb33333333
00ddd00000ddd00000ddd0000000000000000000336b5b3333333333533553353553555333333333333333339999a99900000000a9aa999a3443344333443443
02dddd0002dddd0002dddd000000000000000000353635b3333333335533555353555353333333333333333399aaa99a44444444a99a99a93443344333443443
29ddfdd029ddfdd029ddfdd000000000000000003563655333333333335533535535355533333fff9993333399aa99aa999aa9a9444544453443344344443443
df1ff1d0df1ff1d0df1ff1d00000000000000000355550533366033353333553355555533333ffffff993333999aa99aaa99a99a454545453444344340444443
ddffefd0ddffefd0ddffefd0000000000000000036505003366650333555333355353555333ffffffff99333999aaa9a9a99aa9a454545453344404340555543
0d999d000d999d000d999d0000000000000000003305003335656503335353553555553533ffffffff999933aa9aa99aaaa9999a454545453334404440533333
0011100000111200021110000000000000000000333443336565505335353553535535533ffffffffff99993aa999a99a999a99a454445443333444444533333
0020200000200000000020000000000000000000334540335555000353353353355355353ff22222222229939999a99a99aaaa9aa999a99a3333445044433333
3333333333333333353333335353533533333333333333333333003353000335343353353f22aa2222a7229300000000000000009444449a3333445044433333
3d55355535553555355355335335533533338833333333333300880330000053534335533322aa7227aa22330000000000000000a55554a93333545044433333
3d55355535553555333335335535333333eef8333337333330eef8030000b003553435353322aaa22aaa22330000000000000000944444a93333545444533333
355d555555555555535553333333555333efe333337a733330efe0332b1bb1533000b00533222444444222330000000000000000a45555aa3333500000533333
3555d5555555555555333000ddd3335338fee3333337333308fee03322bbeb35530bb03333222400004222330000000000000000944444993335500000553333
3d585055555058553553000000dd3355388333333333333308800333220003355000000333222400004222330000000000000000955554aa3345400000445333
3dd058555558505535500000000dd335333333333333333330033333530005335000000333222400004222330000000000000000a44444a93444400000444433
35d55555555555553300000000dddd33333333333333333333333333530303533300005533333333333333330000000000000000a455559a3444400000444433
355555555555535530000000000dddd5333773333333333333377333333333330000000000000000000000000000000000000000000000000000000000000000
35555500000555053005555555555dd5337777333333333333777733333333330000000000000000000000000000000000000000000000000000000000000000
35555000000055505055aa5555a755d5370707d3333333333d707073333333330000000000000000000000000000000000000000000000000000000000000000
35555000000055533355aa755aaa55333777767d33333333d7677773333333330000000000000000000000000000000000000000000000000000000000000000
35555000000053503355aaa55aaa5533377086733333333337680773333333330000000000000000000000000000000000000000000000000000000000000000
35555000000055055355500000055535337007633333333336700733333333330000000000000000000000000000000000000000000000000000000000000000
355550000000555353555088880555353377763d33333333d3677733333333330000000000000000000000000000000000000000000000000000000000000000
35555000000055503305508888055035333773633333333336377333333333330000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50505010201010101010105171815151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50505050105010101010107151518151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50504010501010101010101010515181000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50501010101010101010101010815151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10105010101010101010101010105151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30101010101010101010101010101051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2010101010101010101010101010f010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10104010101010101010431010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50101050101010101010101010815110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
501050501010101010101010f0518171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50505010401010101010101010515151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50505050105010101010101051515171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50501050201010301010101010518151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000010101000000000000000000000001010101000001010101000101010101010200020101000002020000000000000005000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0105050101010101010101010115151501010101010117171c1c1c1c17011515150101151501010101010101010101151515151515151515151515151515151505050505050505010101010101151515010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
050201010101010707070705051817150136010f0101171b1b1b1b1b1c17151515150101151515010101010101340115151524150f151515151515150115011505020101010101070707070505181715010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0501050501020706060606010501151701010101013417171b1b1b1b1b17171501011601011501010a09090c010101151501011515011515010101150101161505010505010207060606060105011517010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
05050505010706060606060701161e1f1515161501010117181b1b1b181701160101010101010101080f1708171701150118170d090c15150a0909090909093401010505010706060606060701161e1f010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
05050501070606060606010a09092e2f09090c0115011801010a0909090909340909090c1501150108171708171817151722231717080115080101010f01011505010501070606060606010a09092e2f010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0501010406060a090909090b0116151515010801151515171808010101181815010101080115151508180f08181c18151832331817080f150801160101010f150501010406060a090909090b01161515010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0501010101010804050105050115151515010817151c15151808150117181715010101081501011c2d1c1c2d1c1b18151718181717081615080101010117171505010101010108040501050501151515010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
05030101010108010503010505051715010108151c1b1c1c180815151718171501010108150115012d1b1b2d1b1b1815151717170108011508010f011717171505030101010108010503010505051715010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
050a090909090b01010101051515171701160815151b1b1b1c0817150117171501360108151501152d1b1b2d1b1b1b15161515150f0815150801151718181815050a090909090b010101010515151717010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
05080e0e0e0301010101050505051515010108170a1d1d1d1d0b1717150115150101010d090909090b1b1b0801010115010a0909090b1515081517182728181505080e0e0e0301010101050505051515010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0208030e0e0e0101010101010515051501170d090b1b1b1b1b1818180115011515151515150f010101010108151515150f0801010115151508151517181818150208040e0e0e01010101010105150515010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
02080e0e040e0e0104010105011815151718171c1c1b1b1b1b1c181701010115151718181701010101151508011515150f080101151501150d090c151718171502080e0e030e0e010401010501181515010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0208191a0e0e0e0101050101171718051718181b1b1b1b1b1b170101160f1615151820211715150101151708151515150f080f01150115151515080f150124150208191a0e0e0e010105010117171805010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
020d292a030e0e050501050101171705011717181b1b1b1b171701160124011515183031180f150115150f081817151515080101010f01150115080101151515020d292a0e0e04050501050101171705010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
02040e0e0e040505010301050101050501010117181818181701010116010f151524181817150f151515180d09090909340d09090909093409090b150115151502030e0e0e0405050103010501010505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0505050505050505050505050505050515151515151515151515151515151515151515151515151515151515161515151515151515151515151515151515151505050505050505050505050505050505010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
__sfx__
001000001d550215502355025550285502a550005002d5502e5502f55004200275000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002875023750217501f7501e75021750237501e7501d7502c7002d7002f7003070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
04 41424344

