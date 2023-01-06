#include <a_samp>
#define COLOR_ZIELONY 0xFF00FF

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
	{
if(Nitro(vehicleid))
	{
AddVehicleComponent(vehicleid, 1010);
	}
return 1;
	}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
	{
if(IsPlayerInAnyVehicle(playerid))
	{
new nos = GetPlayerVehicleID(playerid);
if(Nitro(nos) && (oldkeys & 1 || oldkeys & 4))
	{
RemoveVehicleComponent(nos, 1010);
AddVehicleComponent(nos, 1010);
	}
	}
return 1;
	}
	
public OnPlayerConnect(playerid)
	{
return 0;
	}

Nitro(vehicleid)
	{
new nos = GetVehicleModel(vehicleid);
switch(nos) {
case 444:
return 0;
case 581:
return 0;
case 586:
return 0;
case 481:
return 0;
case 509:
return 0;
case 446:
return 0;
case 556:
return 0;
case 443:
return 0;
case 452:
return 0;
case 453:
return 0;
case 454:
return 0;
case 472:
return 0;
case 473:
return 0;
case 484:
return 0;
case 493:
return 0;
case 595:
return 0;
case 462:
return 0;
case 463:
return 0;
case 468:
return 0;
case 521:
return 0;
case 522:
return 0;
case 417:
return 0;
case 425:
return 0;
case 447:
return 0;
case 487:
return 0;
case 488:
return 0;
case 497:
return 0;
case 501:
return 0;
case 548:
return 0;
case 563:
return 0;
case 406:
return 0;
case 520:
return 0;
case 539:
return 0;
case 553:
return 0;
case 557:
return 0;
case 573:
return 0;
case 460:
return 0;
case 593:
return 0;
case 464:
return 0;
case 476:
return 0;
case 511:
return 0;
case 512:
return 0;
case 577:
return 0;
case 592:
return 0;
case 471:
return 0;
case 448:
return 0;
case 461:
return 0;
case 523:
return 0;
case 510:
return 0;
case 430:
return 0;
case 465:
return 0;
case 469:
return 0;
case 513:
return 0;
case 519:
return 0;
	}
return 1;
	}
