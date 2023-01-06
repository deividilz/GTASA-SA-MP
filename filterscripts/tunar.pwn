// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

#include <a_samp>
#pragma tabsize 0

#define FILTERSCRIPT

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREY 0xAFAFAFAA// INFO text messages
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA// warning messages
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_LIGHTGREEN 0x7FFF00
#define COLOR_DARKGREEN 0x006400
#define COLOR_LIGHTBLUE 0x91C8FF//Server text messages
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_GROUPTALK 0x87CEEBAA  // SKYBLUE
#define COLOR_MENU 0xFFFFFFAA		// WHITE (FFFFFF) menu's (/help)
#define COLOR_SYSTEM_PM 0x66CC00AA	// LIGHT GREEN
#define COLOR_SYSTEM_PW 0xFFFF33AA	// YELLOW

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

#if defined FILTERSCRIPT

new Menu:TuningMenu;
new Menu:TuningMenu1;
new Menu:Paintjobs;
new Menu:Colors;
new Menu:Colors1;
new Menu:Exhausts;
new Menu:Frontbumper;
new Menu:Rearbumper;
new Menu:Roof;
new Menu:Spoilers;
new Menu:Sideskirts;
new Menu:Bullbars;
new Menu:Wheels;
new Menu:Wheels1;
new Menu:Carstereo;

new Menu:Hydraulics;
new Menu:Nitro;



public OnFilterScriptInit()
{


	TuningMenu = CreateMenu("TuningMenu",1,20,120,150,40);
    AddMenuItem(TuningMenu,0,"Adesivos");
    AddMenuItem(TuningMenu,0,"Cores");
    AddMenuItem(TuningMenu,0,"Escapes");
    AddMenuItem(TuningMenu,0,"Saia frontal");
    AddMenuItem(TuningMenu,0,"Saia traseira");
    AddMenuItem(TuningMenu,0,"Capo");
    AddMenuItem(TuningMenu,0,"Aerofolio");
    AddMenuItem(TuningMenu,0,"Saias laterais");
    AddMenuItem(TuningMenu,0,"Bullbars");
    AddMenuItem(TuningMenu,0,"Rodas");
    AddMenuItem(TuningMenu,0,"Som Stereo");
    AddMenuItem(TuningMenu,0,"Proxima");
    Paintjobs = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Paintjobs,0,"PaintJobs");
	AddMenuItem(Paintjobs,0,"Paintjob 1");
	AddMenuItem(Paintjobs,0,"Paintjob 2");
	AddMenuItem(Paintjobs,0,"Paintjob 3");
	AddMenuItem(Paintjobs,0,"Paintjob 4");
	AddMenuItem(Paintjobs,0,"Paintjob 5");
	AddMenuItem(Paintjobs,0,"Menu");
	Colors = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Colors,0,"Cors");
	AddMenuItem(Colors,0,"Preto");
	AddMenuItem(Colors,0,"Branco");
	AddMenuItem(Colors,0,"Vermelho");
	AddMenuItem(Colors,0,"Azul");
	AddMenuItem(Colors,0,"Verde");
	AddMenuItem(Colors,0,"Amarelo");
	AddMenuItem(Colors,0,"Rosa");
	AddMenuItem(Colors,0,"Brown");
	AddMenuItem(Colors,0,"Proxima");
	Colors1 = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Colors1,0,"Colors");
    AddMenuItem(Colors1,0,"Grey");
	AddMenuItem(Colors1,0,"Gold");
	AddMenuItem(Colors1,0,"Dark Blue");
	AddMenuItem(Colors1,0,"Light Blue");
	AddMenuItem(Colors1,0,"Green");
	AddMenuItem(Colors1,0,"Light Grey");
	AddMenuItem(Colors1,0,"Dark Red");
	AddMenuItem(Colors1,0,"Dark Brown");
	AddMenuItem(Colors1,0,"Menu");
	Exhausts = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Exhausts,0,"Exhausts");
	AddMenuItem(Exhausts,0,"Wheel Arch Alien Exhaust");
	AddMenuItem(Exhausts,0,"Wheel Arch X-Flow Exhaust");
	AddMenuItem(Exhausts,0,"Loco Low-Co Chromer Exhaust");
	AddMenuItem(Exhausts,0,"Loco Low-Co Slamin Exhaust");
	AddMenuItem(Exhausts,0,"Menu");
	Frontbumper = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Frontbumper,0,"Frontbumpers");
	AddMenuItem(Frontbumper,0,"Wheel Arch Alien bumper");
	AddMenuItem(Frontbumper,0,"Wheel Arch X-Flow bumper");
	AddMenuItem(Frontbumper,0,"Loco Low-Co Chromer bumper");
	AddMenuItem(Frontbumper,0,"Loco Low-Co Slamin bumper");
	AddMenuItem(Frontbumper,0,"Menu");
	Rearbumper = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Rearbumper,0,"Rearbumpers");
	AddMenuItem(Rearbumper,0,"Wheel Arch Alien bumper");
	AddMenuItem(Rearbumper,0,"Wheel Arch X-Flow bumper");
	AddMenuItem(Rearbumper,0,"Loco Low-Co Chromer bumper");
	AddMenuItem(Rearbumper,0,"Loco Low-Co Slamin bumper");
	AddMenuItem(Rearbumper,0,"Main Menu");
	Roof = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Roof,0,"Roof");
	AddMenuItem(Roof,0,"Wheel Arch Alien Roof Vent");
	AddMenuItem(Roof,0,"Wheel Arch X-Flow Roof Vent");
	AddMenuItem(Roof,0,"Loco Low-Co Hardtop Roof");
	AddMenuItem(Roof,0,"Loco Low-Co Softtop Roof");
	AddMenuItem(Roof,0,"Main Menu");
	Spoilers = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Spoilers,0,"Spoliers");
	AddMenuItem(Spoilers,0,"Alien Spoiler");
	AddMenuItem(Spoilers,0,"X-Flow Spoiler");
	AddMenuItem(Spoilers,0,"Menu");
	Sideskirts = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Sideskirts,0,"SideSkirts");
	AddMenuItem(Sideskirts,0,"Wheel Arch Alien Side Skirts");
	AddMenuItem(Sideskirts,0,"Wheel Arch X-Flow Side Skirts");
    AddMenuItem(Sideskirts,0,"Loco Low-Co Chrome Strip");
    AddMenuItem(Sideskirts,0,"Loco Low-Co Chrome Flames");
    AddMenuItem(Sideskirts,0,"Loco Low-Co Chrome Arches");
    AddMenuItem(Sideskirts,0,"Loco Low-Co Chrome Trim");
    AddMenuItem(Sideskirts,0,"Loco Low-Co Wheelcovers");
	AddMenuItem(Sideskirts,0,"Main Menu");
	Bullbars = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Bullbars,0,"Bullbars");
	AddMenuItem(Bullbars,0,"Loco Low-Co Chrome Grill");
	AddMenuItem(Bullbars,0,"Loco Low-Co Chrome Bars");
	AddMenuItem(Bullbars,0,"Loco Low-Co Chrome Lights");
	AddMenuItem(Bullbars,0,"Loco Low-Co Chrome Bullbar");
	AddMenuItem(Bullbars,0,"Main Menu");
	Wheels = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Wheels,0,"Wheels");
	AddMenuItem(Wheels,0,"Offroad");
	AddMenuItem(Wheels,0,"Mega");
	AddMenuItem(Wheels,0,"Wires");
	AddMenuItem(Wheels,0,"Twist");
	AddMenuItem(Wheels,0,"Grove");
	AddMenuItem(Wheels,0,"Import");
	AddMenuItem(Wheels,0,"Atomic");
	AddMenuItem(Wheels,0,"Ahab");
	AddMenuItem(Wheels,0,"Virtual");
	AddMenuItem(Wheels,0,"Access");
	AddMenuItem(Wheels,0,"Next Page");
	AddMenuItem(Wheels,0,"Main Menu");
	Wheels1 = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Wheels1,0,"Wheels");
	AddMenuItem(Wheels1,0,"Trance");
	AddMenuItem(Wheels1,0,"Shadow");
	AddMenuItem(Wheels1,0,"Rimshine");
	AddMenuItem(Wheels1,0,"Classic");
	AddMenuItem(Wheels1,0,"Cutter");
	AddMenuItem(Wheels1,0,"Switch");
	AddMenuItem(Wheels1,0,"Dollar");
	AddMenuItem(Wheels1,0,"Menu");
	Carstereo = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Carstereo,0,"Stereo");
	AddMenuItem(Carstereo,0,"Bass Boost");
	AddMenuItem(Carstereo,0,"Menu");

 	TuningMenu1= CreateMenu("TuningMenu",1,20,120,150,40);
    AddMenuItem(TuningMenu1,0,"Hydraulics");
    AddMenuItem(TuningMenu1,0,"Nitro");
    AddMenuItem(TuningMenu1,0,"Reparar Carro");
    AddMenuItem(TuningMenu1,0,"Menu");
	Hydraulics = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Hydraulics,0,"Hydraulics");
	AddMenuItem(Hydraulics,0,"Hydraulics");
	AddMenuItem(Hydraulics,0,"Menu");
	Nitro = CreateMenu("TuningMenu",1,20,120,150,40);
	SetMenuColumnHeader(Nitro,0,"Nitro");
	AddMenuItem(Nitro,0,"2x Nitrous");
	AddMenuItem(Nitro,0,"5x Nitrous");
	AddMenuItem(Nitro,0,"10x Nitrous");
	AddMenuItem(Nitro,0,"Menu");
	return 1;
}

public OnFilterScriptExit()
{


 return 1;
}

#else


#endif

public OnGameModeInit()
{
return 1;
}



public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_SUBMISSION ){
    
				new playerstate = GetPlayerState(playerid);
				new playername[MAX_PLAYER_NAME];
				GetPlayerName(playerid,playername,sizeof(playername));

				if(!IsPlayerInAnyVehicle(playerid)){

 		    	}
				else
				{
		 	    if(playerstate != PLAYER_STATE_DRIVER){
  			}
				else
				{
                if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 525)
				{

                new vehid = GetPlayerVehicleID(playerid);
				if(!IsTrailerAttachedToVehicle(vehid)){
				new Float:x, Float:y, Float:z;
  				GetVehiclePos(vehid, x, y, z );
				new vehiclet;
				GetVehicleWithinDistance(playerid, x, y, z, 100.0, vehiclet);
				AttachTrailerToVehicle(vehiclet, vehid);
				PlayerPlaySound(playerid, 3016, 0, 0, 0);

				
				}
				else
				{
				DetachTrailerFromVehicle(vehid);
				SendClientMessage(playerid,COLOR_YELLOW,"[INFO] Voce destacou com sucesso esse veiculo");

								
      }
     }
  }

}

}

return 1;
}







GetVehicleWithinDistance( playerid, Float:x1, Float:y1, Float:z1, Float:dist, &vehic){
	for(new i = 1; i < MAX_VEHICLES; i++){
		if(GetVehicleModel(i) > 0){
			if(GetPlayerVehicleID(playerid) != i ){
	        	new Float:x, Float:y, Float:z;
	        	new Float:x2, Float:y2, Float:z2;
				GetVehiclePos(i, x, y, z);
				x2 = x1 - x; y2 = y1 - y; z2 = z1 - z;
				new Float:iDist = (x2*x2+y2*y2+z2*z2);
				printf("Vehicle %d is %f", i, iDist);

				if( iDist < dist){
					vehic = i;
				}
			}
		}
	}
}


public OnPlayerCommandText(playerid, cmdtext[])

{
		if(strcmp(cmdtext, "/tunar", true) == 0)
		 {
	new playerstate = GetPlayerState(playerid);
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid,playername,sizeof(playername));

 if(!IsPlayerInAnyVehicle(playerid)){

	SendClientMessage(playerid,COLOR_WHITE,"[INFO]: Voce nao esta em um carro.");

	return 1;
}
else
{
    if(playerstate != PLAYER_STATE_DRIVER){
	SendClientMessage(playerid,COLOR_YELLOW,"[INFO]: Voce nao esta dirigindo o carro!");


 return 1;

}
else
{


       if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 560 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 || // Broadway
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 535 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 411 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 579 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 597 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 602 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 496 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 518 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 527 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 589 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 597 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 419 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 533 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 526 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 474 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 545 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 517 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 410 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 600 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 436 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 580 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 439 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 549 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 491 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 445 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 604 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 507 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 585 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 587 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 466 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 492 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 546 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 551 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 516 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 467 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 426 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 547 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 405 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 409 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 550 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 566 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 540 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 421 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 529 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 431 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 438 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 437 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 420 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 525 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 552 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 416 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 433 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 427 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 490 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 528 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 407 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 544 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 470 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 598 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 596 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 597 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 599 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 597 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 601 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 428 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 499 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 609 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 524 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 578 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 486 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 406 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 573 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 455 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 588 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 514 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 423 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 414 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 443 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 456 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 422 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 482 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 530 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 418 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 572 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 413 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 440 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 543 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 583 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 478 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 554 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 402 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 542 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 603 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 475 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 568 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 504 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 457 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 483 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 508 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 429 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 541 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 415 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 480 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 434 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 506 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 451 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 555 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 477 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 400 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 404 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 489 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 479 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 442 ||
        GetVehicleModel(GetPlayerVehicleID(playerid)) == 458 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)
       {
		    ShowMenuForPlayer(TuningMenu, playerid);
		    TogglePlayerControllable(playerid,0);
		    SendClientMessage(playerid, 0xFFB200FF,"[INFO]: Você também pode usar o /PINTAR e /NEON");
}
else
{
       SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Nao e permitido voce modificar este veiculo");
}
}
}
		return 1;
		}

		 return 0;
   }







public OnPlayerExitedMenu(playerid)
{

	TogglePlayerControllable(playerid, true);
	return 1;
}
public OnPlayerSelectedMenuRow(playerid, row)

{

new Menu:Current = GetPlayerMenu(playerid);
    if(Current == TuningMenu) {
    switch(row){
        case 0:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Paintjobs, playerid);
			}
        case 1:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Colors, playerid);
			}
        case 2:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Exhausts, playerid);
			}
        case 3:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Frontbumper, playerid);
			}
        case 4:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Rearbumper, playerid);
			}
        case 5:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Roof, playerid);
			}
        case 6:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Spoilers, playerid);
			}
        case 7:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Sideskirts, playerid);
			}
			
		case 8:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Bullbars, playerid);
			}
        case 9:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Wheels, playerid);
			}
        case 10:
            if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Carstereo, playerid);
			}
        case 11:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(TuningMenu1, playerid);
			}
	}
	}
	
if(Current == Paintjobs) {
	switch(row){
	    case 0:
	        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 || // Broadway
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 535 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)
	        {
				new car = GetPlayerVehicleID(playerid);
				ChangeVehiclePaintjob(car,0);
				SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou um paintjob com sucesso no carro");
				ShowMenuForPlayer(Paintjobs, playerid);

			}
			else
			{

			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 1:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 || // Broadway
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 535 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)
		    {
                new car = GetPlayerVehicleID(playerid);
				ChangeVehiclePaintjob(car,1);
				SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou um paintjob com sucesso no carro");
				ShowMenuForPlayer(Paintjobs, playerid);
	}
			else
			{

			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 2:
      		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 || // Broadway
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 535 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)
		    {
                new car = GetPlayerVehicleID(playerid);
				ChangeVehiclePaintjob(car,2);
				SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou um paintjob com sucesso no carro");
				ShowMenuForPlayer(Paintjobs, playerid);
	}
			else
			{
			  
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 3:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 || // Broadway
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 535 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)
		    {
                new car = GetPlayerVehicleID(playerid);
				ChangeVehiclePaintjob(car,3);
				SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou um paintjob com sucesso no carro");
				ShowMenuForPlayer(Paintjobs, playerid);
	}
			else
			{
       	
			    ShowMenuForPlayer(TuningMenu, playerid);
		}

		case 4:
	    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 || // Broadway
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 535 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)
		    {
                new car = GetPlayerVehicleID(playerid);
				ChangeVehiclePaintjob(car,4);
				SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou um paintjob com sucesso no carro");
				ShowMenuForPlayer(Paintjobs, playerid);
	}
			else
			{
      
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
			case 5:
		{
	    	ShowMenuForPlayer(TuningMenu, playerid);
		}
	
	}
	}

if(Current == Colors) {
	switch(row){
	    case 0:
         if(GetPlayerMoney(playerid) >= 0)
	        {
	            new car = GetPlayerVehicleID(playerid);
	            ChangeVehicleColor(car,0,0);
	            //GivePlayerMoney(playerid,-150);
	            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou um paintjob com sucesso no carro");
	            ShowMenuForPlayer(Colors, playerid);
   }
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 1:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,1,1);
		       //GivePlayerMoney(playerid,-150);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 2:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,3,3);
		       //GivePlayerMoney(playerid,-150);
		         SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 3:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,79,79);
		        //GivePlayerMoney(playerid,-150);
		         SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
         SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 4:
			if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,86,86);
		       //GivePlayerMoney(playerid,-150);
		         SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
            SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 5:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,6,6);
		        //GivePlayerMoney(playerid,-150);
		          SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
            SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
            case 6:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,126,126);
		       //GivePlayerMoney(playerid,-150);
		          SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 7:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,66,66);
		        //GivePlayerMoney(playerid,-150);
          		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou um paintjob com sucesso no carro");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
			    SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 8:ShowMenuForPlayer(Colors1, playerid);
 }
 }

if(Current == Colors1) {
	switch(row){
	    case 0:
         if(GetPlayerMoney(playerid) >= 0)
	        {
	            new car = GetPlayerVehicleID(playerid);
	            ChangeVehicleColor(car,24,24);
	            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou um paintjob com sucesso no carro");
	            ShowMenuForPlayer(Colors1, playerid);
			}
			else
			{
			    SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
         case 1:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,123,123);
               SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");

			    ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 2:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,53,53);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro!!!");
		        ShowMenuForPlayer(Colors1, playerid);
			}
			else
			{
  	    SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 3:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,93,93);
		          SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 4:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,83,83);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 5:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,60,60);
		          SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
            case 6:
      		if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,126,126);
		           SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 7:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        ChangeVehicleColor(car,110,110);
		         SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce repintou o carro com sucesso");
		        ShowMenuForPlayer(Colors, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro para isso!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 8:ShowMenuForPlayer(TuningMenu, playerid);
 }
 }


 if(Current == Exhausts) {
	switch(row){



	    case 0:

	        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
	        {
	            new car = GetPlayerVehicleID(playerid);
	            if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562)
	            {
	            	AddVehicleComponent(car,1034);
	            	SendClientMessage(playerid,COLOR_WHITE,"[INFO]  Voce adicionou Wheel Arch Alien Exhaust componente com sucesso no Elegy");
	            	ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565)
				{
				    AddVehicleComponent(car,1046);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien Exhaust componente com sucesso no Flash");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559)
				{
				    AddVehicleComponent(car,1065);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien Exhaust componente com sucesso no Jetser");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561)
				{
				    AddVehicleComponent(car,1064);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien Exhaust componente com sucesso no Stratum");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
				{
				    AddVehicleComponent(car,1028);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien Exhaust componente com sucesso no Sultan");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)
				{
				    AddVehicleComponent(car,1089);
			 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien Exhaust component no Uranus");
				    ShowMenuForPlayer(Exhausts, playerid);
    			}
				}
  			 	else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode somente adicionar esse componet a Wheel Arch Angels esse tipo de carro");
				ShowMenuForPlayer(TuningMenu, playerid);
				}



	case 1:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)

		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562)
		        {
		            AddVehicleComponent(car,1037);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch X-Flow Exhaust componente no Elegy");
		            ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565)
				{
				    AddVehicleComponent(car,1045);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch X-Flow Exhaustcomponente no Flash");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559)
				{
				    AddVehicleComponent(car,1066);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch X-Flow exaust componente no Jester");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561)
				{
				    AddVehicleComponent(car,1059);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch X-Flow Exhaust componente no Stratum");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
				{
				    AddVehicleComponent(car,1029);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch X-Flow Exhaust componente no Sultan");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)
				{
				    AddVehicleComponent(car,1092);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch X-Flow Exhaust componente no Uranus");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a carros tipo Wheel Arch Angels!");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

	case 2:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 535)

		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575) // Brodway
		        {
		            AddVehicleComponent(car,1044);
	             	SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chromer Exhaust componente no Brodway");
		            ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)// Remington
				{
				    AddVehicleComponent(car,1126);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chromer Exhaust componente no Remington");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567)// Savanna
				{
				    AddVehicleComponent(car,1129);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chromer Exhaust componente no Savana");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 536) // Blade
				{
				    AddVehicleComponent(car,1104);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chromer Exhaust componente no Blade");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535) // Slamvan
				{
				    AddVehicleComponent(car,1113);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chromer Exhaust componente no Slamvan");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 576) // Tornado
				{
				    AddVehicleComponent(car,1136);
				   	SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chromer Exhaust componente no Tornado");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a carros tipo Loco Low-Co!");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

	case 3:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 535)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575) // Brodway
		        {
		            AddVehicleComponent(car,1043);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Slamin Exhaust componente no Brodway");
		            ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)// Remington
				{
				    AddVehicleComponent(car,1127);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Slamin Exhaust componente no Remingon");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567)// Savanna
				{
				    AddVehicleComponent(car,1132);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Slamin Exhaust componente no Savana");
				    ShowMenuForPlayer(Exhausts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 536) // Blade
				{
				    AddVehicleComponent(car,1105);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Slamin Exhaust componente no Blade");
				    ShowMenuForPlayer(Exhausts, playerid);
				}

					else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535) // Slamvan
				{
				    AddVehicleComponent(car,1114);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Slamin Exhaust componente no Slamvan");
				    ShowMenuForPlayer(Exhausts, playerid);
				}

				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 576) // Tornado
				{
				    AddVehicleComponent(car,1135);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Slamin Exhaust componente no Tornado");
				    ShowMenuForPlayer(Exhausts, playerid);
				}

				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a carros tipo Loco Low-Co!");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

		case 4:ShowMenuForPlayer(TuningMenu, playerid);
	}
	}

	if(Current == Frontbumper) {
	switch(row){


    case 0:
	        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
			{
	            new car = GetPlayerVehicleID(playerid);
	            if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562) // Elegy
	            {
	            	AddVehicleComponent(car,1171);
              		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien front bumper componente no Elegy");
	            	ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565) // Flash
				{
				    AddVehicleComponent(car,1153);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien front bumper componente no Flash");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559) // Jester
				{
				    AddVehicleComponent(car,1160);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien front bumper componente no Jester");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561) // Stratum
				{
				    AddVehicleComponent(car,1155);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien front bumper componente no Stratum");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560) // Sultan
				{
				    AddVehicleComponent(car,1169);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien front bumper componente no Sultan");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558) // Uranus
				{
				    AddVehicleComponent(car,1166);
			 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch Alien front bumper componente no Uraus");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a carros tipo Wheel Arch Angels!");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

		case 1:

			if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
	        {

		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562) // Elegy
		        {
		            AddVehicleComponent(car,1172);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch X-Flow front bumper component on Elegy");
		            ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565) // Flash
				{
				    AddVehicleComponent(car,1152);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch  X-Flow front bumper component on Flash");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559) // Jetser
				{
				    AddVehicleComponent(car,1173);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch  X-Flow front bumper component on Jester");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561) // Stratum
				{
				    AddVehicleComponent(car,1157);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch  X-Flow front bumper component on Stratum");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560) // Sultan
				{
				    AddVehicleComponent(car,1170);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch  X-Flow front bumper component on Sultan");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)  // Uranus
				{
				    AddVehicleComponent(car,1165);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wheel Arch  X-Flow front bumper component on Uranus");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a carros tipo  Wheel Arch Angels!");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

		case 2:
		
      		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 535)
			{
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575) // Brodway
		        {
		            AddVehicleComponent(car,1174);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer front bumper component on Brodway");
		            ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)// Remington
				{
				    AddVehicleComponent(car,1179);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer front bumper component on Remington");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567)// Savanna
				{
				    AddVehicleComponent(car,1189);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer front bumper component on Savana");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 536) // Blade
				{
				    AddVehicleComponent(car,1182);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer front bumper component on Blade");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535) // Slamvan
				{
				    AddVehicleComponent(car,1115);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer front bumper component on Slamvan");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 576) // Tornado
				{
				    AddVehicleComponent(car,1191);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer front bumper component on Tornado");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce pode adicionar apenas um componente Low-Co Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}



		case 3:
		
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
            GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575) // Brodway
		        {
		            AddVehicleComponent(car,1175);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin front bumper component on Brodway");
		            ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)// Remington
				{
				    AddVehicleComponent(car,1185);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin front bumper component on Remington");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567)// Savanna
				{
				    AddVehicleComponent(car,1188);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin front bumper component on Savana");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 536) // Blade
				{
				    AddVehicleComponent(car,1181);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin front bumper component on Blade");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}

			    else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535) // Slamvan
				{
				    AddVehicleComponent(car,1116);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin front bumper component on Slamvan");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 576) // Tornado
				{
				    AddVehicleComponent(car,1190);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin front bumper component on Tornado");
				    ShowMenuForPlayer(Frontbumper, playerid);
				}

				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce pode adicionar apenas um componente Low-Co Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

		case 4:ShowMenuForPlayer(TuningMenu, playerid);
	}
	}


if(Current == Rearbumper) {
	switch(row){


	    case 0:
	        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
	        {

	            new car = GetPlayerVehicleID(playerid);
	            if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562) // Elegy
	            {
	            	AddVehicleComponent(car,1149);
              		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Yvoce adicionou Wheel Arch Alien rear bumper component on Elegy");
	            	ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565) // Flash
				{
				    AddVehicleComponent(car,1150);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien rear bumper component on Flash");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559) // Jester
				{
				    AddVehicleComponent(car,1159);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien rear bumper component on Jester");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561) // Stratum
				{
				    AddVehicleComponent(car,1154);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien rear bumper component on Stratum");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560) // Sultan
				{
				    AddVehicleComponent(car,1141);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien rear bumper component on Sultan");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558) // Uranus
				{
				    AddVehicleComponent(car,1168);
			 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien rear bumper component on Uranus");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce ja adicionou Wheel Arch Angels Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

		case 1:

			if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
	        {


		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562) // Elegy
		        {
		            AddVehicleComponent(car,1148);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch  X-Flow rear bumper component on Elegy");
		            ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565) // Flash
				{
				    AddVehicleComponent(car,1151);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch  X-Flow rear bumper component on Flash");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559) // Jetser
				{
				    AddVehicleComponent(car,1161);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch  X-Flow rear bumper component on Jester");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561) // Stratum
				{
				    AddVehicleComponent(car,1156);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch  X-Flow rear bumper component on Stratum");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560) // Sultan
				{
				    AddVehicleComponent(car,1140);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch  X-Flow rear bumper component on Sultan");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)  // Uranus
				{
				    AddVehicleComponent(car,1167);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch  X-Flow rear bumper component on Uranus");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce ja adicionou Wheel Arch Angels Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}
		case 2:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 535)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575) // Brodway
		        {
		            AddVehicleComponent(car,1176);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer rear bumper component on Brodway");
		            ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)// Remington
				{
				    AddVehicleComponent(car,1180);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer rear bumper component on Remington");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567)// Savanna
				{
				    AddVehicleComponent(car,1187);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer rear bumper component on Savana");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 536) // Blade
				{
				    AddVehicleComponent(car,1184);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer rear bumper component on Blade");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535) // Slamvan
				{
				    AddVehicleComponent(car,1109);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer rear bumper component on Slamvan");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 576) // Tornado
				{
				    AddVehicleComponent(car,1192);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chromer rear bumper component on Tornado");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce adicionou Low-Co Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}
		case 3:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 535)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575) // Brodway
		        {
		            AddVehicleComponent(car,1177);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin rear bumper component on Brodway");
		            ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)// Remington
				{
				    AddVehicleComponent(car,1178);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin rear bumper component on Remington");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567)// Savanna
				{
				    AddVehicleComponent(car,1186);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin rear bumper component on Savana");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 536) // Blade
				{
				    AddVehicleComponent(car,1183);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin rear bumper component on Blade");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}
				
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535) // Slamvan
				{
				    AddVehicleComponent(car,1110);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin rear bumper component on Slamvan");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}

				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 576) // Tornado
				{
				    AddVehicleComponent(car,1193);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Slamin rear bumper component on Tornado");
				    ShowMenuForPlayer(Rearbumper, playerid);
				}

				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce não pode adicionar este componente Low-Co Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

		case 4:ShowMenuForPlayer(TuningMenu, playerid);
	}
	}



if(Current == Roof) {
	switch(row){


	    case 0:
	        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
	        {

	            new car = GetPlayerVehicleID(playerid);
	            if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562) // Elegy
	            {
	            	AddVehicleComponent(car,1035);
              		SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien roof vent component on Elegy");
	            	ShowMenuForPlayer(Roof, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565) // Flash
				{
				    AddVehicleComponent(car,1054);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien roof vent component on Flash");
				    ShowMenuForPlayer(Roof, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559) // Jester
				{
				    AddVehicleComponent(car,1067);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien roof vent component on Jester");
				    ShowMenuForPlayer(Roof, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561) // Stratum
				{
				    AddVehicleComponent(car,1055);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien roof vent component on Stratum");
				    ShowMenuForPlayer(Roof, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560) // Sultan
				{
				    AddVehicleComponent(car,1032);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien roof vent component on Sultan");
				    ShowMenuForPlayer(Roof, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558) // Uranus
				{
				    AddVehicleComponent(car,1088);
			 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien roof vent component on Uranus");
				    ShowMenuForPlayer(Roof, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce ja adicionou Wheel Arch Angels Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

		case 1:

			if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
	        {


		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562) // Elegy
		        {
		            AddVehicleComponent(car,1035);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow roof vent component on Elegy");
		            ShowMenuForPlayer(Roof, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565) // Flash
				{
				    AddVehicleComponent(car,1053);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow roof vent component on Flash");
				    ShowMenuForPlayer(Roof, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559) // Jetser
				{
				    AddVehicleComponent(car,1068);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow roof vent component on Jester");
				    ShowMenuForPlayer(Roof, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561) // Stratum
				{
				    AddVehicleComponent(car,1061);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow roof vent component on Stratum");
				    ShowMenuForPlayer(Roof, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560) // Sultan
				{
				    AddVehicleComponent(car,1033);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow roof vent component on Sultan");
				    ShowMenuForPlayer(Roof, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)  // Uranus
				{
				    AddVehicleComponent(car,1091);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow roof vent component on Uranus");
				    ShowMenuForPlayer(Roof, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce ja adicionou Wheel Arch Angels Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}
		case 2:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567) // Savana
		        {
		            AddVehicleComponent(car,1130);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Hardtop Roof component on Brodway");
		            ShowMenuForPlayer(Roof, playerid);
				}
   				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 536) // Blade
				{
				    AddVehicleComponent(car,1128);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Hardtop Roof component on Blade");
				    ShowMenuForPlayer(Roof, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce ja adicionou Loco Low-Co Car types Savana and Blade");
				ShowMenuForPlayer(Roof, playerid);
				}
		case 3:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 536)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567) // Savana
		        {
		            AddVehicleComponent(car,1131);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Softtop Roof component on Brodway");
		            ShowMenuForPlayer(Roof, playerid);
				}
   				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 536) // Blade
				{
				    AddVehicleComponent(car,1103);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Softtop Roof component on Blade");
				    ShowMenuForPlayer(Roof, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce ja adicionou Low-Co Car types Savana and Blade");
				ShowMenuForPlayer(Roof, playerid);
				}
				
		case 4:ShowMenuForPlayer(TuningMenu, playerid);
	}
	}


        if(Current == Spoilers) {
	switch(row){


	    case 0:
	        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
	        {

	            new car = GetPlayerVehicleID(playerid);
	            if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562) // Elegy
	            {
	            	AddVehicleComponent(car,1147);
              		SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Spoilers component on Elegy");
	            	ShowMenuForPlayer(Spoilers, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565) // Flash
				{
				    AddVehicleComponent(car,1049);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Spoilers component on Flash");
				    ShowMenuForPlayer(Spoilers, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559) // Jester
				{
				    AddVehicleComponent(car,1162);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Spoilers component on Jester");
				    ShowMenuForPlayer(Spoilers, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561) // Stratum
				{
				    AddVehicleComponent(car,1158);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Spoilers component on Stratum");
				    ShowMenuForPlayer(Spoilers, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560) // Sultan
				{
				    AddVehicleComponent(car,1138);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Spoilers component on Sultan");
				    ShowMenuForPlayer(Spoilers, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558) // Uranus
				{
				    AddVehicleComponent(car,1164);
			 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Spoilers component on Uranus");
				    ShowMenuForPlayer(Spoilers, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce ja adicionou Wheel Arch Angels Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}


		case 1:

			if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
	        {


		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562) // Elegy
		        {
		            AddVehicleComponent(car,1146);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Spoilers component on Elegy");
		            ShowMenuForPlayer(Spoilers, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565) // Flash
				{
				    AddVehicleComponent(car,1150);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Spoilers component on Flash");
				    ShowMenuForPlayer(Spoilers, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559) // Jetser
				{
				    AddVehicleComponent(car,1158);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Spoilers component on Jester");
				    ShowMenuForPlayer(Spoilers, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561) // Stratum
				{
				    AddVehicleComponent(car,1060);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Spoilers component on Stratum");
				    ShowMenuForPlayer(Spoilers, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560) // Sultan
				{
				    AddVehicleComponent(car,1139);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Yvoce adicionou Wheel Arch X-Flow Spoilers component on Sultan");
				    ShowMenuForPlayer(Spoilers, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)  // Uranus
				{
				    AddVehicleComponent(car,1163);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Spoilers component on Uranus");
				    ShowMenuForPlayer(Spoilers, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce ja adicionou X-Flow Arch Angels Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

        	case 2:
			{
            ShowMenuForPlayer(TuningMenu, playerid);
            }
	}
	}


if(Current == Sideskirts) {
	switch(row){


	    case 0:
	        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
	        {

	            new car = GetPlayerVehicleID(playerid);
	            if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562) // Elegy
	            {
	            	AddVehicleComponent(car,1036);
	            	AddVehicleComponent(car,1040);
              		SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Side Skirts component on Elegy");
	            	ShowMenuForPlayer(Sideskirts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565) // Flash
				{
				    AddVehicleComponent(car,1047);
				    AddVehicleComponent(car,1051);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Sideskirts vent component on Flash");
				    ShowMenuForPlayer(Sideskirts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559) // Jester
				{
				    AddVehicleComponent(car,1069);
				    AddVehicleComponent(car,1071);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Side Skirts component on Jester");
				    ShowMenuForPlayer(Sideskirts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561) // Stratum
				{
				    AddVehicleComponent(car,1056);
				    AddVehicleComponent(car,1062);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Side Skirts component on Stratum");
				    ShowMenuForPlayer(Sideskirts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560) // Sultan
				{
				    AddVehicleComponent(car,1026);
				    AddVehicleComponent(car,1027);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Side Skirts bumper component on Sultan");
				    ShowMenuForPlayer(Sideskirts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558) // Uranus
				{
				    AddVehicleComponent(car,1090);
				    AddVehicleComponent(car,1094);
			 	    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch Alien Side Skirts component on Uranus");
				    ShowMenuForPlayer(Sideskirts, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce ja adicionou Wheel Arch Angels Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

	case 1:

			if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 565 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 560)
	        {


		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 562) // Elegy
		        {
		            AddVehicleComponent(car,1039);
		            AddVehicleComponent(car,1041);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Side Skirts component on Elegy");
		            ShowMenuForPlayer(Sideskirts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 565) // Flash
				{
				    AddVehicleComponent(car,1048);
				    AddVehicleComponent(car,1052);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Side Skirts component on Flash");
				    ShowMenuForPlayer(Sideskirts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 559) // Jetser
				{
				    AddVehicleComponent(car,1070);
				    AddVehicleComponent(car,1072);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Side Skirts component on Jester");
				    ShowMenuForPlayer(Sideskirts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561) // Stratum
				{
				    AddVehicleComponent(car,1057);
				    AddVehicleComponent(car,1063);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Side Skirts component on Stratum");
				    ShowMenuForPlayer(Sideskirts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 560) // Sultan
				{
				    AddVehicleComponent(car,1031);
				    AddVehicleComponent(car,1030);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Side Skirts component on Sultan");
				    ShowMenuForPlayer(Sideskirts, playerid);
				}
				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 558)  // Uranus
				{
				    AddVehicleComponent(car,1093);
				    AddVehicleComponent(car,1095);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Wheel Arch X-Flow Side Skirts component on Uranus");
				    ShowMenuForPlayer(Sideskirts, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] voce ja adicionou Wheel Arch Angels Car types");
				ShowMenuForPlayer(TuningMenu, playerid);
				}
  
		case 2:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575 ||
               GetVehicleModel(GetPlayerVehicleID(playerid)) == 536 ||
               GetVehicleModel(GetPlayerVehicleID(playerid)) == 576 ||
	 	       GetVehicleModel(GetPlayerVehicleID(playerid)) == 567)
               {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 575) // Brodway
		        {
       		        AddVehicleComponent(car,1042);
       		        AddVehicleComponent(car,1099);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chrome Strip Side Skirts component on Brodway");
		            ShowMenuForPlayer(Sideskirts, playerid);
				}
   				else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 567) // Savana
				{
				    AddVehicleComponent(car,1102);
				    AddVehicleComponent(car,1133);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chrome Strip Side Skirts component on Savana");
    		        ShowMenuForPlayer(Sideskirts, playerid);
                }
                else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 576) // Tornado
				{
				    AddVehicleComponent(car,1134);
				    AddVehicleComponent(car,1137);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] voce adicionou Low-Co Chrome Strip Side Skirts component on Tornado");
    		        ShowMenuForPlayer(Sideskirts, playerid);
                }
                else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 536) // Blade
				{
				    AddVehicleComponent(car,1108);
				    AddVehicleComponent(car,1107);
				    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou added Loco Low-Co Chrome Strip Side Skirts componente em Blade");
                    ShowMenuForPlayer(Sideskirts, playerid);
                }
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[[AVISO] Voce pode adicionar este componente a  Loco Low-Co tipo Brodway, Savana Tornado e Blade");
				ShowMenuForPlayer(TuningMenu, playerid);
				}
		case 3:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534) // Remington
		        {
		            AddVehicleComponent(car,1122);
		            AddVehicleComponent(car,1101);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chrome Flames Side Skirts componente em Remington");
		            ShowMenuForPlayer(Sideskirts, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a Loco Low-Co tipo Remington ");
				ShowMenuForPlayer(TuningMenu, playerid);
				}
		case 4:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534 ||
			GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534) // Remington
		        {
		            AddVehicleComponent(car,1106);
		            AddVehicleComponent(car,1124);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chrome Arches Side Skirts componente em Remington");
		            ShowMenuForPlayer(Sideskirts, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[[AVISO] Voce pode adicionar este componente a Loco Low-Co Car tipo Remington ");
				ShowMenuForPlayer(TuningMenu, playerid);
				}




		case 5:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535)
			
		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535) // Slamvan
		        {
		            AddVehicleComponent(car,1118);
		            AddVehicleComponent(car,1120);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chrome Trim Side Skirts componente em Slamvan");
		            ShowMenuForPlayer(Sideskirts, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[[AVISO] Voce pode adicionar este componente a Loco Low-Co tipo Slamvan ");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

  case 6:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535)
			
		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535) // Slamvan
		        {
		            AddVehicleComponent(car,1119);
		            AddVehicleComponent(car,1121);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chrome Wheelcovers componente em Slamvan");
		            ShowMenuForPlayer(Sideskirts, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a Loco Low-Co tipo Slamvan ");
				ShowMenuForPlayer(TuningMenu, playerid);
				}

		   case 7:ShowMenuForPlayer(TuningMenu, playerid);
	}
	}


if(Current == Bullbars) {
	switch(row){

        case 0:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)

		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534) // Remington
		        {
		            AddVehicleComponent(car,1100);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chrome Grill componente em Remington");
		            ShowMenuForPlayer(Bullbars, playerid);
		        }
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a Loco Low-Co tipo Remington ");
				ShowMenuForPlayer(TuningMenu, playerid);
				}
		case 1:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)

		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534) // Remington
		        {
		            AddVehicleComponent(car,1123);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou  Loco Low-Co Chrome Bars componente em Remington");
		            ShowMenuForPlayer(Bullbars, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a Loco Low-Co tipo Remington ");
				ShowMenuForPlayer(TuningMenu, playerid);
				}


		case 2:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534)

		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 534) // Remington
		        {
		            AddVehicleComponent(car,1125);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chrome Lights componente em Remington");
		            ShowMenuForPlayer(Bullbars, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a carros Low-Co tipo Remington ");
				ShowMenuForPlayer(TuningMenu, playerid);
				}



        case 3:
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535)

		    {
		        new car = GetPlayerVehicleID(playerid);
		        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 535) // Slamvan
		        {
		            AddVehicleComponent(car,1117);
		            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Loco Low-Co Chrome Lights componente em Slamvan");
		            ShowMenuForPlayer(Bullbars, playerid);
				}
				}
				else
				{
			    SendClientMessage(playerid,COLOR_YELLOW,"[AVISO] Voce pode adicionar este componente a carros Loco Low-Co tipo Slamvan ");
				ShowMenuForPlayer(TuningMenu, playerid);
				}








		case 4:ShowMenuForPlayer(TuningMenu, playerid);
	}
	}



if(Current == Wheels) {
	switch(row){
	    case 0:
         if(GetPlayerMoney(playerid) >= 0)
	        {
	            new car = GetPlayerVehicleID(playerid);
	            AddVehicleComponent(car,1025);
	            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Offroad Wheels no carro!");
	            ShowMenuForPlayer(Wheels, playerid);
			}
			else
			{
SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 1:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1074);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Mega Wheels no carro!");
		        ShowMenuForPlayer(Wheels, playerid);
			}
			else
			{
SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 2:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1076);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Wires Wheels no carro!");
		        ShowMenuForPlayer(Wheels, playerid);
			}
			else
			{
SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 3:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1078);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Twist Wheels no carro!");
		        ShowMenuForPlayer(Wheels, playerid);
			}
			else
			{
SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(Wheels, playerid);
			}
		case 4:
			if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1081);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Grove Wheels no carro!");
		        ShowMenuForPlayer(Wheels, playerid);
			}
			else
			{
SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 5:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1082);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Import Wheels no carro!");
		        ShowMenuForPlayer(Wheels, playerid);
			}
			else
			{
		SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
   		case 6:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1085);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Atomic Wheels no carro!");
		        ShowMenuForPlayer(Wheels, playerid);
			}
			else
			{
SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 7:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1096);
          		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Ahab Wheels no carro!");
		        ShowMenuForPlayer(Wheels, playerid);
			}
			else
			{
			  SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 8:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1097);
          		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Virtual Wheels no carro!");
		        ShowMenuForPlayer(Wheels, playerid);
			}
			else
			{
			   SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
 		case 9:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1098);
          		SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Access Wheels no carro!");
		        ShowMenuForPlayer(Wheels, playerid);
			}
			else
			{
	SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
        case 10:
			{

			    ShowMenuForPlayer(Wheels1, playerid);
			}

		case 11:
			{

			    ShowMenuForPlayer(TuningMenu, playerid);
			}

 }
 }



if(Current == Wheels1) {
	switch(row){
	    case 0:
         if(GetPlayerMoney(playerid) >= 0)
	        {
	            new car = GetPlayerVehicleID(playerid);
	            AddVehicleComponent(car,1084);
	            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Trance Wheels no carro! ");
	            ShowMenuForPlayer(Wheels1, playerid);
			}
			else
			{
   SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 1:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1073);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Shadow Wheels no carro!");
		        ShowMenuForPlayer(Wheels1, playerid);
			}
			else
			{
SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 2:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1075);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Rimshine Wheels no carro!");
		        ShowMenuForPlayer(Wheels1, playerid);
			}
			else
			{
SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 3:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1077);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Classic Wheels no carro!");
		        ShowMenuForPlayer(Wheels1, playerid);
			}
			else
			{
    SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(Wheels, playerid);
			}
		case 4:
			if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1079);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Cutter Wheels no carro!");
		        ShowMenuForPlayer(Wheels1, playerid);
			}
			else
			{
 			    SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 5:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1080);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Switch Wheels no carro!");
		        ShowMenuForPlayer(Wheels1, playerid);
			}
			else
			{
			    SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
   		case 6:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1083);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Dollar Wheels no carro!");
		        ShowMenuForPlayer(Wheels1, playerid);
			}
			else
			{
			    SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
        case 7:
			{

			    ShowMenuForPlayer(TuningMenu, playerid);
			}
 }
 }



if(Current == Carstereo) {
	switch(row){
	    case 0:
         if(GetPlayerMoney(playerid) >= 0)
	        {
	            new car = GetPlayerVehicleID(playerid);
	            AddVehicleComponent(car,1086);
	            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Stereo Bass bost system ");
	            ShowMenuForPlayer(Carstereo, playerid);
			}
			else
			{
               SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
		    }
		case 1:

		    {
		        ShowMenuForPlayer(TuningMenu, playerid);
			}
 }
 }

if(Current == Hydraulics) {
	switch(row){
	    case 0:
            if(GetPlayerMoney(playerid) >= 0)
	        {
	            new car = GetPlayerVehicleID(playerid);
	            AddVehicleComponent(car,1087);
	            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou Hydraulics no carro! ");
	            ShowMenuForPlayer(Hydraulics, playerid);
			}
			else
			{
                SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
		    }

		case 1:

		    {
		        ShowMenuForPlayer(TuningMenu, playerid);
			}
 }
 }
 
 if(Current == Nitro) {
	switch(row){
	    case 0:
         if(GetPlayerMoney(playerid) >= 0)
	        {
	            new car = GetPlayerVehicleID(playerid);
	            AddVehicleComponent(car,1008);
 //GivePlayerMoney(playerid, -998);
new string[128];
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "*** %s colocou nitro no proprio veiculo ( /tunar )", pname);
//SendClientMessageToAll(0x33CCFFAA, string);
GameTextForPlayer(playerid," Nitrado!",2000,3);
	            SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou 2x Nitro no carro! ");
	            ShowMenuForPlayer(Nitro, playerid);
			}
			else
			{
                SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
		    }
		case 1:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
		        AddVehicleComponent(car,1009);
		         //GivePlayerMoney(playerid, -998);
new string[128];
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "*** %s colocou nitro no proprio veiculo ( /tunar )", pname);
//SendClientMessageToAll(0x33CCFFAA, string);
GameTextForPlayer(playerid," Nitrado!",2000,3);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou 5x Nitro no carro!");
		        ShowMenuForPlayer(Nitro, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 2:
		    if(GetPlayerMoney(playerid) >= 0)
		    {
		        new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1010);
                 //GivePlayerMoney(playerid, -998);
new string[128];
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "*** %s colocou nitro no proprio veiculo ( /tunar )", pname);
//SendClientMessageToAll(0x33CCFFAA, string);
GameTextForPlayer(playerid," Nitrado!",2000,3);
		        SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce adicionou 10x Nitro no carro!");
		        ShowMenuForPlayer(Nitro, playerid);
			}
			else
			{
       SendClientMessage(playerid,COLOR_RED,"Voce nao tem dinheiro suficiente!");
			    ShowMenuForPlayer(TuningMenu, playerid);
			}
		case 3:

		    {
		        ShowMenuForPlayer(TuningMenu, playerid);
			}
 }
 }


if(Current == TuningMenu1) {
    switch(row){
        case 0:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Hydraulics, playerid);
			}
        case 1:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(Nitro, playerid);
			}
       case 2:
			{
			
	if(GetPlayerMoney(playerid) < 2000)
	{
	SendClientMessage(playerid, COLOR_RED, "Reparar o carro: $2000 Voce nao tem esse dinheiro.");
	ShowMenuForPlayer(TuningMenu1, playerid);
	}

//GivePlayerMoney(playerid, -2000);
			
			new pname[MAX_PLAYER_NAME];
			new string[128];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
format(string, sizeof(string), "*** %s consertou o proprio veiculo ( /tunar )", pname);
//SendClientMessageToAll(0x33AA33AA, string);
			
			
                new car = GetPlayerVehicleID(playerid);
                
                
                
				SetVehicleHealth(car,1000);
			 	SendClientMessage(playerid,COLOR_WHITE,"[INFO] Voce reparou o carro com sucesso, isso lhe custou $2000");
				ShowMenuForPlayer(TuningMenu1, playerid);
				
			}
			
       case 3:
			if(IsPlayerConnected(playerid))
			{
				ShowMenuForPlayer(TuningMenu, playerid);
			}
			
			
	}
	}
			   return 0;

			   }

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com
