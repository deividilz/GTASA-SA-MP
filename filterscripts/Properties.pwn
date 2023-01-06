// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

/*===================================================================================================*\
||===================================================================================================||
||	              ________    ________    ___    _    ______     ______     ________                 ||
||	        \    |   _____|  |  ____  |  |   \  | |  |   _  \   |  _   \   |  ____  |    /           ||
||	======== \   |  |_____   | |____| |  | |\ \ | |  |  | |  |  | |_|  /   | |____| |   / ========   ||
||	          |  | _____  |  |  ____  |  | | \ \| |  |  | |  |  |  _  \    |  ____  |  |             ||
||	======== /    ______| |  | |    | |  | |  \ \ |  |  |_|  |  | |  \ \   | |    | |   \ ========   ||
||	        /    |________|  |_|    |_|  |_|   \__|  |______/   |_|   \_|  |_|    |_|    \           ||
||                                                                                                   ||
||                                                                                                   ||
||                                  Property-Filterscript - Striker Samp                             ||
||                                                                                                   ||
||===================================================================================================||
||                           Created on the 5st of June 2008 by =>Sandra<=                          ||
||                                    Do NOT remove any credits!!                                    ||
\*===================================================================================================*/

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

#include <a_samp>
#include <dini>
#pragma tabsize 0

#define MAX_PROPERTIES 300
#define MAX_PROPERTIES_PER_PLAYER 20
#define UNBUYABLETIME 30  //If a propertie is bought, someone else have to wait this number of minutes before he/she can buy it.

#define ENABLE_LOGIN_SYSTEM 0
#define ENABLE_MAP_ICON_STREAMER 1

#define REGISTER_COMMAND "/register"
#define LOGIN_COMMAND "/login"
#define COLOR_LIMON	0x33FF33AA

#define COLOUR_INFORMACAO 0x00FF00FF
#define COLOUR_AVISO 0xFFFF00FF
#define COLOUR_ERRO 0xFF0000FF
#define COLOUR_TELEPORTE 0x09D19BFF
#define COLOUR_DICA 0xFFB200FF
#define COLOUR_EVENTO 0xFF5A00FF
#define COLOUR_EVENTOCANCELADO 0xC1C1C1FF
#define COLOUR_CHATPROX 0x00FFFFFF
#define COLOUR_BRANCO 0xFFFFFFFF
#define COLOUR_CINZA 0xC1C1C1FF
#define COLOUR_PINK 0xFF00FFFF

new UltimaPropVendida[MAX_PLAYERS];
new PropertiesAmount;
new MP;
enum propinfo
{
	PropName[64],
	Float:PropX,
	Float:PropY,
	Float:PropZ,
	PropIsBought,
	PropUnbuyableTime,
	PropOwner[MAX_PLAYER_NAME],
	PropValue,
	PropEarning,
	PickupNr,
}
new PropInfo[MAX_PROPERTIES][propinfo]; //CarInfo
new PlayerProps[MAX_PLAYERS];
new EarningsForPlayer[MAX_PLAYERS];
new Logged[MAX_PLAYERS];


stock IsATrain(playerid)
{
if(!IsPlayerInAnyVehicle(playerid)) return 0;
new md = GetVehicleModel(GetPlayerVehicleID(playerid));
if(md == 537 ||md == 538 ||md == 570 ||md == 590 ||md == 569 ||md == 449) return 1;
return 0;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnFilterScriptInit()
{
    AntiDeAMX();
    LoadProperties();
//	SetTimer("SalvarTimer", 900000, 1);
    MP = GetMaxPlayers();
	for(new i; i<MP; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new pName[MAX_PLAYER_NAME];
			GetPlayerName(i, pName, MAX_PLAYER_NAME);
			for(new propid; propid < PropertiesAmount; propid++)
			{
				if(PropInfo[propid][PropIsBought] == 1)
				{
				    if(strcmp(PropInfo[propid][PropOwner], pName, true)==0)
					{
					    EarningsForPlayer[i] += PropInfo[propid][PropEarning];
					    PlayerProps[i]++;
					}
				}
			}
		}
	}
    SetTimer("UpdateUnbuyableTime", 60111, 1);
	#if ENABLE_MAP_ICON_STREAMER == 1
	SetTimer("MapIconStreamer", 500, 1);
	#endif
	SetTimer("PropertyPayout", 120000, 1);
	//SetTimer("PropertyPayout", 2000, 1);
	//print("-------------------------------------------------");
	//print("Property-System by =>Sandra<= Succesfully loaded!");
	//print("-------------------------------------------------");
	return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnFilterScriptExit()
{
    SaveProperties();
	return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward TransferirProps(playerid, nick[], novonick[]);
public TransferirProps(playerid, nick[], novonick[]){
for(new propid; propid < PropertiesAmount; propid++)
{
	if(PropInfo[propid][PropIsBought] == 1)
		{
		    if(strcmp(PropInfo[propid][PropOwner], nick, true)==0)
				{
					format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, novonick);
					}
				}
			}
OnPlayerConnect(playerid);
return 1;}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward ResetarProps(playerid, playername[]);
public ResetarProps(playerid, playername[]){
for(new propid; propid < PropertiesAmount; propid++)
{
	if(PropInfo[propid][PropIsBought] == 1)
		{
		    if(strcmp(PropInfo[propid][PropOwner], playername, true)==0)
				{
					format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "Ninguem");
					PropInfo[propid][PropIsBought] = 0;
					PropInfo[propid][PropUnbuyableTime] = 0;
					}
				}
			}

OnPlayerConnect(playerid);

return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward VenderTodasProps(nickname[],playerid);
public VenderTodasProps(nickname[],playerid){
new str[500];

for(new propid; propid < PropertiesAmount; propid++)
			{
				if(PropInfo[propid][PropIsBought] == 1)
				{
				    if(strcmp(PropInfo[propid][PropOwner], nickname, true)==0)
					{
					
							format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "Ninguem");
							PropInfo[propid][PropIsBought] = 0;
							PropInfo[propid][PropUnbuyableTime] = 0;
							//GivePlayerMoney(playerid, (PropInfo[propid][PropValue]/2));
							CallRemoteFunction("GivePlayerCash", "ii", playerid,(PropInfo[propid][PropValue]/2));
							format(str, 128, "[INFO]: Você vendeu sua propriedade \"%s\" por metade do valor: $%d", PropInfo[propid][PropName], PropInfo[propid][PropValue]/2);
					        SendClientMessage(playerid, 0xFFFF00AA, str);
					        PlayerProps[playerid]--;
					        EarningsForPlayer[playerid] -= PropInfo[propid][PropEarning];

					}
				}
			}


OnPlayerConnect(playerid);

return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnPlayerConnect(playerid)
{
    UltimaPropVendida[playerid] = -1;
    PlayerProps[playerid] = 0;
    Logged[playerid] = 0;
    EarningsForPlayer[playerid] = 0;
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	for(new propid; propid < PropertiesAmount; propid++)
	{
		if(PropInfo[propid][PropIsBought] == 1)
		{
		    if(strcmp(PropInfo[propid][PropOwner], pName, true)==0)
			{
			    EarningsForPlayer[playerid] += PropInfo[propid][PropEarning];
			    PlayerProps[playerid]++;
			}
		}
	}
	#if ENABLE_LOGIN_SYSTEM == 0
	if(PlayerProps[playerid] > 0)
	{
	    new str[128];
	    format(str, 128, "[AVISO]: Você é dono de %d propriedades. Digite /minhasprops para mais informações.", PlayerProps[playerid]);
	    SendClientMessage(playerid, 0x99FF66AA, str);
	}
	#endif
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[100], idx;
	cmd = strtok(cmdtext, idx);
	
	if(strcmp(cmd, "/svprops", true)==0){
	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,0x66CCFFAA,"ERRO: Voce nao tem permissao para isso.");
	SendClientMessage(playerid, 0x66CCFFAA, "Salvando propriedades...");
	SaveProperties();
	SendClientMessage(playerid, 0x66CCFFAA, "Propriedades salvas!");
	return 1;}
	
	if(strcmp(cmd, "/pprops", true)==0){
	if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,0x66CCFFAA,"ERRO: Voce nao tem permissao para isso.");
	new parametro[100],parametro_int;
	parametro = strtok(cmdtext, idx);
	parametro_int = strval(parametro);
	if(!strlen(parametro)) return SendClientMessage(playerid,COLOUR_ERRO,"USO: /pprops <id>");
	if(!IsNumeric(parametro)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: ID Inválida");
	if(!IsPlayerConnected(parametro_int)) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Jogador não conectado");
	new str[150],ownerid,pname[MAX_PLAYER_NAME],TotalPProps;
	GetPlayerName(parametro_int, pname, MAX_PLAYER_NAME);
	format(str, 150, "[INFO]: Listagem das propriedades de: {C1C1C1}%s (%i)", pname, parametro_int);
	SendClientMessage(playerid, COLOUR_INFORMACAO, str);
	for(new propid; propid < PropertiesAmount; propid++)
	{
		if(PropInfo[propid][PropIsBought] == 1)
		{
  		ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
			if(ownerid == parametro_int)
			{
			format(str, 150, ">> \"%s\"   Valor: $%d -   Lucro: $%d - Tempo: %i minuto (s)", PropInfo[propid][PropName], PropInfo[propid][PropValue], PropInfo[propid][PropEarning], PropInfo[propid][PropUnbuyableTime]);
			SendClientMessage(playerid, 0xC1C1C1AA, str);
			TotalPProps++;
			}
		}
	}
	format(str, 150, "[INFO]: %s (%i) - Propriedades: %i - Debug: %i", pname, parametro_int, TotalPProps, PlayerProps[parametro_int]);
	SendClientMessage(playerid, COLOUR_INFORMACAO, str);
	if(TotalPProps != PlayerProps[parametro_int]) SendClientMessage(playerid, COLOUR_ERRO, "[INFO]: BUG DETECTADO NO SISTEMA DE PROPRIEDADES! COMUNIQUE MOTOXEX OU DIRECT3D!");
	return 1;}
	
	
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/propriedades", true)==0 || strcmp(cmd, "/prophelp", true)==0)
	{
	    SendClientMessage(playerid, 0x6699FFAA, "|=========================================================|");
//	    new str[128];
	    SendClientMessage(playerid, 0x6699FFAA, "Comandos relacionados a propriedades:");
	    #if ENABLE_LOGIN_SYSTEM == 1
	    format(str, 128, "%s  ==>> To register your name in our property-database", REGISTER_COMMAND);
	    SendClientMessage(playerid, 0x66CCFFAA, str);
	    format(str, 128, "%s  ==>> To log into our property-database", LOGIN_COMMAND);
	    SendClientMessage(playerid, 0x66CCFFAA, str);
		#endif
	    SendClientMessage(playerid, 0x66CCFFAA, "/comprar ou /buyprop  ==>> Comprar propriedade");
	    SendClientMessage(playerid, 0x66CCFFAA, "/vender ou /sellprop  ==>> Vender propriedade");
	    SendClientMessage(playerid, 0x66CCFFAA, "/minhasprops or /myprops  ==>> Lista as suas propriedades");
     if(IsPlayerAdmin(playerid))
	    {
	        SendClientMessage(playerid, 0x66CCFFAA, "/sellallproperties [Admin Only] ==>> To sell all properties for all players");
		}
	    SendClientMessage(playerid, 0x6699FFAA, "|=========================================================|");
	    return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/comprar", true)==0 || strcmp(cmd, "/buyprop", true)==0)
	{
	    if(GetPlayerVirtualWorld(playerid) > 0) return SendClientMessage(playerid, 0xFF0000AA, "[ERRO]: Você não pode comprar propriedades fora da dimensão/world padrão");
	    new str[128];
	    #if ENABLE_LOGIN_SYSTEM == 1
		if(Logged[playerid] == 0)
		{
		    format(str, 128, "You have to login before you can buy or sell properties! Use: %s", LOGIN_COMMAND);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		#endif
		
		new propid = IsPlayerNearProperty(playerid);
		if(propid == -1)
		{
			SendClientMessage(playerid, 0xFF0000AA, "[ERRO]: Você não está próximo o suficiente da propriedade.");
			return 1;
		}
		
		if(IsPlayerNearProperty(playerid) == UltimaPropVendida[playerid]) return SendClientMessage(playerid, 0xFF0000AA, "[ERRO]: Você não pode comprar novamente a última propriedade vendida");
		
		/*if(GetPlayerScore(playerid) < 20){
		SendClientMessage(playerid, 0xFF0000AA, "Você deve ter mais de 20 de SCORE para comprar propriedades.");
		SendClientMessage(playerid, 0xFF0000AA, "Ganhe pontos de score matando pessoas no servidor!");
	    return 1;}*/
		
		if(PlayerProps[playerid] >= MAX_PROPERTIES_PER_PLAYER)
	    {
			format(str, 128, "[ERRO]: Você já tem %d propriedades, Você não pode comprar mais propriedades!", PlayerProps[playerid]);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		if(PropInfo[propid][PropIsBought] == 1)
		{
			new ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
			if(ownerid == playerid)
			{
			    SendClientMessage(playerid, 0xFF0000AA, "[ERRO]: Você já é dono desta propriedade!");
			    return 1;
			}
			else
			{
			    if(PropInfo[propid][PropUnbuyableTime] > 0)
			    {
					format(str, 128, "[ERRO]: Esta propriedade já foi comprada por %s. Você deve esperar %d minutos antes de comprá-la.", PropInfo[propid][PropOwner], PropInfo[propid][PropUnbuyableTime]);
				    SendClientMessage(playerid, 0xFF0000AA, str);
				    return 1;
				}
			}
		}
		if(CallRemoteFunction("GetPlayerCash", "i", playerid) < PropInfo[propid][PropValue])
		{
		    format(str, 128, "[ERRO]: Você não tem dinheiro o suficiente! Você precisa de $%d", PropInfo[propid][PropValue]);
		    SendClientMessage(playerid, 0xFF0000AA, str);
		    return 1;
		}
		new pName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pName, sizeof(pName));
		if(PropInfo[propid][PropIsBought] && PropInfo[propid][PropUnbuyableTime] == 0)
		{

				new ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
				if (IsPlayerConnected(ownerid)){
		    	format(str, 128, "[AVISO]: %s comprou a sua propriedade: \"%s\". Você recebeu metade do valor dela. ($%d)", pName, PropInfo[propid][PropName], (PropInfo[propid][PropValue]/2));
		    	CallRemoteFunction("GivePlayerCash", "ii", ownerid,(PropInfo[propid][PropValue]/2));
				//GivePlayerMoney(ownerid, (PropInfo[propid][PropValue]/2));
				SendClientMessage(ownerid, 0xFFFF00AA, str);
				PlayerProps[ownerid]--;//AKIDAPAU
				EarningsForPlayer[ownerid] -= PropInfo[propid][PropEarning];
				//OnPlayerConnect(ownerid);
				}
		}
		PropInfo[propid][PropOwner] = pName;
		PropInfo[propid][PropIsBought] = 1;
		PropInfo[propid][PropUnbuyableTime] = UNBUYABLETIME;
		EarningsForPlayer[playerid] += PropInfo[propid][PropEarning];
        //GivePlayerMoney(playerid, (0-PropInfo[propid][PropValue]));
        CallRemoteFunction("GivePlayerCash", "ii", playerid,(0-PropInfo[propid][PropValue]));
		format(str, 128, "[INFO]: Você comprou a propriedade \"%s\" por $%d", PropInfo[propid][PropName], PropInfo[propid][PropValue]);
        SendClientMessage(playerid, 0xFFFF00AA, str);
        format(str, 128, "[INFO]: %s comprou a propriedade \"%s\".", pName, PropInfo[propid][PropName]);
        SendClientMessageToAllEx(playerid, 0xFFFF00AA, str);
        PlayerProps[playerid]++;
		return 1;
	}
    //================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/vender", true) == 0 || strcmp(cmd, "/sellprop", true) == 0)
	{
		if(GetPlayerVirtualWorld(playerid) > 0) return SendClientMessage(playerid, 0xFF0000AA, "[ERRO]: Você não pode vender propriedades fora da dimensão/world padrão");
	    new str[128];
	    #if ENABLE_LOGIN_SYSTEM == 1
		if(Logged[playerid] == 0)
		{
		    format(str, 128, "You have to login before you can buy or sell properties! Use: %s", LOGIN_COMMAND);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		#endif
		new propid = IsPlayerNearProperty(playerid);
		if(propid == -1)
		{
			SendClientMessage(playerid, 0xFF0000AA, "[ERRO]: Você não está próximo o suficiente da propriedade.");
			return 1;
		}
		//if(PropInfo[propid][PropIsBought] == 1)
		//{
			new ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
			if(ownerid != playerid)
			{
			    SendClientMessage(playerid, 0xFF0000AA, "[ERRO]: Você não é o dono desta propriedade!");
			    return 1;
			}
		//}
		new pName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pName, sizeof(pName));
		format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "Ninguem");
		PropInfo[propid][PropIsBought] = 0;
		PropInfo[propid][PropUnbuyableTime] = 0;
		//GivePlayerMoney(playerid, (PropInfo[propid][PropValue]/2));
		CallRemoteFunction("GivePlayerCash", "ii", playerid,(PropInfo[propid][PropValue]/2));
		format(str, 128, "[INFO]: Você vendeu sua propriedade \"%s\" por metade do valor: $%d", PropInfo[propid][PropName], PropInfo[propid][PropValue]/2);
        SendClientMessage(playerid, 0xFFFF00AA, str);
        format(str, 128, "[INFO]: %s vendeu a propriedade \"%s\".", pName, PropInfo[propid][PropName]);
        UltimaPropVendida[playerid] = IsPlayerNearProperty(playerid);
        SendClientMessageToAllEx(playerid, 0xFFFF00AA, str);
        PlayerProps[playerid]--;
        EarningsForPlayer[playerid] -= PropInfo[propid][PropEarning];
		return 1;
	}
    //================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
    if(strcmp(cmd, "/minhasprops", true) == 0 || strcmp(cmd, "/myprops", true) == 0)
	{
	    new str[128], ownerid;
	    #if ENABLE_LOGIN_SYSTEM == 1
		if(Logged[playerid] == 0)
		{
		    format(str, 128, "You have to login before you can buy or sell properties! Use: %s", LOGIN_COMMAND);
			SendClientMessage(playerid, 0xFF0000AA, str);
			return 1;
		}
		#endif
	    if(PlayerProps[playerid] == 0)
	    {
	        SendClientMessage(playerid, 0xFF0000AA, "[ERRO]: Você não tem propriedades!");
	        return 1;
		}
		format(str, 128, "|====================== Suas %d Propriedades: =======================|", PlayerProps[playerid]);
	    SendClientMessage(playerid, 0x99FF66AA, str);
		for(new propid; propid < PropertiesAmount; propid++)
		{
			if(PropInfo[propid][PropIsBought] == 1)
			{
                ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
				if(ownerid == playerid)
				{
 					format(str, 150, ">> \"%s\"   Valor: $%d -   Lucro: $%d - Tempo: %i minuto (s)", PropInfo[propid][PropName], PropInfo[propid][PropValue], PropInfo[propid][PropEarning], PropInfo[propid][PropUnbuyableTime]);
 					SendClientMessage(playerid, 0x99FF66AA, str);
				}
			}
		}
		SendClientMessage(playerid, 0x99FF66AA, "|===============================================================|");
		return 1;
	}
	//================================================================================================================================
		if (strcmp("/salvarprops", cmdtext, true, 10) == 0)
	{
		    if(IsPlayerAdmin(playerid))
	    {
	    SaveProperties();
	    SendClientMessage(playerid, 0xFF9966AA, "Propriedades salvas!");
	    return 1;
	    }
	}
	//================================================================================================================================
	//================================================================================================================================
	#if ENABLE_LOGIN_SYSTEM == 1
	if(strcmp(cmd, REGISTER_COMMAND, true) == 0)
	{
	    new str[128];
	    if(Logged[playerid] == 1) return SendClientMessage(playerid, 0xFF0000AA, "You're already logged in!");
	    tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp))
		{
		    format(str, 128, "Use: %s 'Your Password'", REGISTER_COMMAND);
			SendClientMessage(playerid, 0xFF9966AA, str);
			return 1;
		}
	    if(strlen(tmp) < 5) return SendClientMessage(playerid, 0xFF9966AA, "Password too short! At least 5 characters.");
	    if(strlen(tmp) > 20) return SendClientMessage(playerid, 0xFF9966AA, "Password too long! Max 20 characters.");
	    new pName[MAX_PLAYER_NAME], pass;
	    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
		pass = dini_Int("PropertySystem/PlayerAccounts.txt", pName);
		if(pass == 0)
		{
		    dini_IntSet("PropertySystem/PlayerAccounts.txt", pName, encodepass(tmp));
		    Logged[playerid] = 1;
			format(str, 128, "Your name is now registered in our property-database. Next time use \"%s %s\" to login", LOGIN_COMMAND, tmp);
			SendClientMessage(playerid, 0x99FF66AA, str);
		}
		else
		{
			format(str, 128, "This name is already registered! Use %s to login!", LOGIN_COMMAND);
            SendClientMessage(playerid, 0xFF9966AA, str);
	    }
	    return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, LOGIN_COMMAND, true) == 0)
	{
	    new str[128];
	    if(Logged[playerid] == 1) return SendClientMessage(playerid, 0xFF0000AA, "You're already logged in!");
	    tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp))
		{
		    format(str, 128, "Use: %s 'Your Password'", LOGIN_COMMAND);
			SendClientMessage(playerid, 0xFF9966AA, str);
			return 1;
		}
	    new pName[MAX_PLAYER_NAME], pass;
	    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
		pass = dini_Int("PropertySystem/PlayerAccounts.txt", pName);
		if(pass == 0)
		{
		    format(str, 128, "This name is not registered yet! Use %s to register this name!", REGISTER_COMMAND);
            SendClientMessage(playerid, 0xFF9966AA, str);
		}
		else
		{
			if(pass == encodepass(tmp))
			{
			    Logged[playerid] = 1;
			    SendClientMessage(playerid, 0x99FF66AA, "You're now logged in! You can now buy and sell properties!");
			}
			else
			{
			    SendClientMessage(playerid, 0xFF0000AA, "Wrong Password");
			}
	    }
	    #if ENABLE_LOGIN_SYSTEM == 1
	    if(PlayerProps[playerid] > 0)
		{
		    format(str, 128, "You currently own %d properties. Type /myproperties for more info about them.", PlayerProps[playerid]);
		    SendClientMessage(playerid, 0x99FF66AA, str);
		}
		#endif
	    return 1;
	}
	#endif
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	if(strcmp(cmd, "/sellallproperties", true)==0)
	{
	    if(IsPlayerAdmin(playerid))
	    {
	        for(new propid; propid<PropertiesAmount; propid++)
	        {
	            format(PropInfo[propid][PropOwner], MAX_PLAYER_NAME, "Ninguem");
	            PropInfo[propid][PropIsBought] = 0;
	            PropInfo[propid][PropUnbuyableTime] = 0;
			}
		   for(new i; i < GetMaxPlayers(); i++)
			{
			    if(IsPlayerConnected(i))
			    {
			        PlayerProps[i] = 0;
				}
			}
			new str[128], pName[24];
			GetPlayerName(playerid, pName, 24);
			format(str, 128, "Admin %s has resetou todas as propriedades!", pName);
			SendClientMessageToAll(0xFFCC66AA, str);
		}
		return 1;
	}
	//================================================================================================================================
	//================================================================================================================================
	//================================================================================================================================
	return 0;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnPlayerPickUpPickup(playerid, pickupid)
{
	new propid = -1;
	for(new id; id<MAX_PROPERTIES; id++)
	{
		if(PropInfo[id][PickupNr] == pickupid)
		{
			propid = id;
            break;
		}
	}
	if(propid != -1)
	{
	    new str[128];
    	format(str, 128, "~y~\"%s\"~n~~r~Valor: ~y~$%d~n~~r~Lucro: ~y~$%d~n~~r~Dono: ~y~%s", PropInfo[propid][PropName], PropInfo[propid][PropValue], PropInfo[propid][PropEarning], PropInfo[propid][PropOwner]);
		GameTextForPlayer(playerid, str, 6000, 3);
		/*
		new ownerid = GetPlayerID(PropInfo[propid][PropOwner]);
		new playermoney = CallRemoteFunction("GetPlayerCash", "i", playerid);
		
		if(ownerid != playerid && PropInfo[propid][PropUnbuyableTime] <= 0 && playermoney >= PropInfo[propid][PropValue] && PlayerProps[playerid] < MAX_PROPERTIES_PER_PLAYER)
		SendClientMessage(playerid, 0x99FF66AA, "[INFO] Compre esta propriedade digitando: /COMPRAR");
		
		if(ownerid == playerid && PropInfo[propid][PropUnbuyableTime] <= 0)
		SendClientMessage(playerid, 0x99FF66AA, "[INFO] Venda esta propriedade digitando: /VENDER");
		*/
	}
	return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock LoadProperties()
{
	if(fexist("PropertySystem/PropertyInfo.txt"))
	{
	    CountProperties();
		new Argument[9][70];
		new entry[256], BoughtProps;
		new File: propfile = fopen("PropertySystem/PropertyInfo.txt", io_read);
	    if (propfile)
		{
		    for(new id; id<PropertiesAmount; id++)
			{
				fread(propfile, entry);
				split(entry, Argument, ',');
				format(PropInfo[id][PropName], 64, "%s", Argument[0]);
				PropInfo[id][PropX] = floatstr(Argument[1]);
				PropInfo[id][PropY] = floatstr(Argument[2]);
				PropInfo[id][PropZ] = floatstr(Argument[3]);
				PropInfo[id][PropValue] = strval(Argument[4]);
				PropInfo[id][PropEarning] = strval(Argument[5]);
				format(PropInfo[id][PropOwner], MAX_PLAYER_NAME, "%s", Argument[6]);
				PropInfo[id][PropIsBought] = strval(Argument[7]);
				PropInfo[id][PropUnbuyableTime] = strval(Argument[8]);
				PropInfo[id][PickupNr] = CreatePickup(1273, 1, PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ]);
    			if(PropInfo[id][PropIsBought] == 1)
				{
				    BoughtProps++;
				}
			}
			fclose(propfile);
			//printf("===================================");
			//printf("||    Created %d Properties     ||", PropertiesAmount);
			//printf("||%d of the properties are bought||", BoughtProps);
			//printf("===================================");
		}
	}
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward SaveProperties();
public SaveProperties()
{
	new entry[256];
	new File: propfile = fopen("PropertySystem/PropertyInfo.txt", io_write);
	for(new id; id<PropertiesAmount; id++)
	{
	    format(entry, 128, "%s,%.2f,%.2f,%.2f,%d,%d,%s,%d,%d \r\n",PropInfo[id][PropName], PropInfo[id][PropX], PropInfo[id][PropY], PropInfo[id][PropZ], PropInfo[id][PropValue], PropInfo[id][PropEarning], PropInfo[id][PropOwner], PropInfo[id][PropIsBought], PropInfo[id][PropUnbuyableTime]);
		fwrite(propfile, entry);
	}
	printf("Saved %d Properties!", PropertiesAmount);
	fclose(propfile);
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward split(const strsrc[], strdest[][], delimiter);
public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock CountProperties()
{
    new entry[256];
	new File: propfile = fopen("PropertySystem/PropertyInfo.txt", io_read);
	while(fread(propfile, entry, 256))
	{
		PropertiesAmount++;
  	}
  	fclose(propfile);
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward IsPlayerNearProperty(playerid);
public IsPlayerNearProperty(playerid)
{
	new Float:Distance;
	for(new prop; prop<PropertiesAmount; prop++)
	{
	    Distance = GetDistanceToProperty(playerid, prop);
	    if(Distance < 1.0)
	    {
	        return prop;
		}
	}
	return -1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward Float:GetDistanceToProperty(playerid, Property);
public Float:GetDistanceToProperty(playerid, Property)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	GetPlayerPos(playerid,x1,y1,z1);
	x2 = PropInfo[Property][PropX];
	y2 = PropInfo[Property][PropY];
	z2 = PropInfo[Property][PropZ];
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock GetPlayerID(const Name[])
{
	for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i))
	{
	        new pName[MAX_PLAYER_NAME];
			GetPlayerName(i, pName, sizeof(pName));
	        if(strcmp(Name, pName, true)==0)
	        {
	            return i;
			}
	}}
	return -1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock SendClientMessageToAllEx(exeption, color, const message[])
{
	for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i))
	{
		    if(i != exeption)
		    {
		        SendClientMessage(i, color, message);
			}
	}}
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward UpdateUnbuyableTime();
public UpdateUnbuyableTime()
{
	for(new propid; propid<PropertiesAmount; propid++)
	{
	    if(PropInfo[propid][PropIsBought] == 1)
	    {
			if(PropInfo[propid][PropUnbuyableTime] > 0)
			{
	        	PropInfo[propid][PropUnbuyableTime]--;
			}
		}
	}
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock encodepass(buf[]) {
	new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward MapIconStreamer();
public MapIconStreamer()
{
	for(new i; i<MP; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new Float:SmallestDistance = 99999.9;
	        new CP, Float:OldDistance;
	        for(new propid; propid<PropertiesAmount; propid++)
	        {
	            OldDistance = GetDistanceToProperty(i, propid);
	            if(OldDistance < SmallestDistance)
	            {
	                SmallestDistance = OldDistance;
	                CP = propid;
				}
			}
			RemovePlayerMapIcon(i, 31);
			//if(PropInfo[CP][PropIsBought] == 1) // ICONES POR COMPRADAS OU NÃO
			
			if(PropInfo[CP][PropUnbuyableTime] > 0) //ICONES POR TEMPO E DONO
			{
                SetPlayerMapIcon(i, 31, PropInfo[CP][PropX], PropInfo[CP][PropY], PropInfo[CP][PropZ], 32, 0);
			}
			else
			{
			    SetPlayerMapIcon(i, 31, PropInfo[CP][PropX], PropInfo[CP][PropY], PropInfo[CP][PropZ], 31, 0);
			}
		}
	}
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward PropertyPayout();
public PropertyPayout()
{
	new str[70];
	for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerProps[i] > 0)
	        {
	            if(!IsATrain(i))
	            {
	                if(IsPlayerInRangeOfPoint(i, 4370.0, 0, 0, 0))
	                {
						if(CallRemoteFunction("GetPlayerAwaySeconds", "i", i) < 120)
						{
        	 			CallRemoteFunction("GivePlayerCash", "ii", i,EarningsForPlayer[i]);
						format(str, 70, "[INFO]: Você recebeu $%d de suas propriedades!", EarningsForPlayer[i]);
						SendClientMessage(i, 0xFFFF00AA, str);
						}else{
						SendClientMessage(i, 0xFFFF00AA, "[INFO]: Você não recebeu nada de suas propriedades por estar inativo há mais de 2 minutos!");
						}
					}else{SendClientMessage(i, 0xFFFF00AA, "[INFO]: Você não recebeu nada de suas propriedades por estar longe do continente!");}
				}else{SendClientMessage(i, 0xFFFF00AA, "[INFO]: Você não recebeu nada de suas propriedades por estar dentro de um bonde ou trem!");}
			}
		}
	}
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward SalvarTimer();public SalvarTimer(){SaveProperties();}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

AntiDeAMX()
{
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock IsNumeric(string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com
