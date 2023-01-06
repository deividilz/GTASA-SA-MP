/*
				FS DE CRIAÇÃO DE GANGS
					BY LUCAS_ALEMAO

			NÃO RETIRE A PORRA DOS CRÉDITOS --'
			
			Inicio do Script: 17/02/2012
			Final do Script: --/--/----
*/

#include    <   a_samp  >
#include    <   dof2    >
#include    <   zcmd    >
#include    <   sscanf2 >

#define MAX_GANGS               100

#define VERMELHO                0xFF030FFF
#define VERMELHO_CLARO          0xFB0000FF
#define AMARELO                 0xFFFF00FF
#define AZUL_CLARO              0x00C2ECFF
#define ROXO                    0xB360FDFF
#define VERDE_CLARO             0x38FF06FF
#define CINZA                   0xCECECEFF

//dialogs do lider
#define DIALOG_CRIAR            4518
#define DIALOG_INFO             4519
#define DIALOG_NOMEG            4520
#define DIALOG_SKIN             4521
#define DIALOG_CONVIDAR         4522
#define DIALOG_PROMOVER         4524
#define DIALOG_PROMOVER2        4525
#define DIALOG_DEMITIR          4526
#define DIALOG_CARROS           4527
#define DIALOG_SPAWN            4528
#define DIALOG_COR              4529
#define DIALOG_TAG              4530
#define DIALOG_ENCERRAR         4531

#define DIALOG_CONVIDADO        4523

enum Dados
{
	Lider,
	Membro,
	Cargo,
	bool:CCarro1,
	bool:CCarro2,
	bool:CCarro3,
	bool:LocalSpawn
}

new PlayerDados[MAX_PLAYERS][Dados];

enum GangsInfo
{
	ID,
	Nomeg,
	Cor,
	Skin,
	SpawnX,
	SpawnY,
	SpawnZ,
	Carro1,
	Carro2,
	Carro3,
	Tag
}

new GangInfo[MAX_GANGS][GangsInfo];
new String[256];
new StringGang[256];
new Gang[MAX_GANGS];
new gangs;
new IdConvidou;
new IdGangC;
new IdPromovido;
new CargoNome[128];

forward SpawnGang(playerid);

public OnFilterScriptInit()
{
	print("\n\n");
	print("-------------------------------------------------------------------------");
	print("    §§§§     §§     §§§§§ §§§§     §§§§     §§§§     §§§§§§§  §§  §§§§§§");
	print("   §§  §§    §§     §     §§ §§   §§ §§    §§  §§    §§   §§   §  §§");
	print("  §§§§§§§§   §§     §§§§§ §§  §§ §§  §§   §§§§§§§§   §§   §§  §   §§§§§§");
	print(" §§      §§  §§     §     §§   §§§   §§  §§      §§  §§   §§          §§");
	print("§§        §§ §§§§§§ §§§§§ §§         §§ §§        §§ §§§§§§§      §§§§§§");
	print("\n");
	print("                  §§§§§       §§§§     §§§§    §§   §§§§§");
	print("                 §§          §§  §§    §§ §§   §§  §§");
	print("                §§  §§§§    §§    §§   §§  §§  §§ §§  §§§§");
	print("                §§     §§  §§§§§§§§§§  §§   §§ §§ §§     §§");
	print("                 §§§§§§§  §§        §§ §§    §§§§  §§§§§§§");
	print("\n");
	print("     	          FS DE CRIACAO DE GANGS BY LUCAS_ALEMAO");
	print("-------------------------------------------------------------------------");
	print("\n\n");
	return 1;
}

public OnFilterScriptExit()
{
	DOF2_Exit();
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SalvarDados(playerid);
	DOF2_Exit();
	return 1;
}

public OnPlayerSpawn(playerid)
{
    format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	PlayerDados[playerid][Membro] = DOF2_GetInt(String, "Membro");
	PlayerDados[playerid][Lider] = DOF2_GetInt(String, "Lider");
	PlayerDados[playerid][Cargo] = DOF2_GetInt(String, "Cargo");
	if(ContaExiste(playerid))
	{
	    format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	    PlayerDados[playerid][Lider] = DOF2_GetInt(String, "Lider");
	    PlayerDados[playerid][Membro] = DOF2_GetInt(String, "Membro");
	    PlayerDados[playerid][Cargo] = DOF2_GetInt(String, "Cargo");
	    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	    if(!DOF2_FileExists(String))
	    {
	        PlayerDados[playerid][Membro] = 0;
	        PlayerDados[playerid][Cargo] = 0;
 		}
		SetTimerEx("SpawnGang", 10, false, "i", playerid);
	}
	if(!ContaExiste(playerid))
	{
	    format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
		DOF2_CreateFile(String);
		DOF2_SetInt(String, "Lider", PlayerDados[playerid][Lider]);
		DOF2_SetInt(String, "Membro", PlayerDados[playerid][Membro]);
		DOF2_SetInt(String, "Cargo", PlayerDados[playerid][Cargo]);
	}
	if(PlayerDados[playerid][Membro] == 1) return CargoNome = "Recruta";
	if(PlayerDados[playerid][Membro] == 2) return CargoNome = "Aprendiz";
	if(PlayerDados[playerid][Membro] == 3) return CargoNome = "Matador";
	if(PlayerDados[playerid][Membro] == 4) return CargoNome = "Profissional";
	if(PlayerDados[playerid][Membro] == 5) return CargoNome = "Poderoso Chefão";
	return 1;
}

public SpawnGang(playerid)
{
    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
    if(DOF2_FileExists(String))
 	{
 	    new str[100];
		format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
 	    if(DOF2_IsSet(String, "Skin")) SetPlayerSkin(playerid, ArquivoGangInt(playerid, "Skin"));
 	    if(DOF2_IsSet(String, "SpawnX") && DOF2_IsSet(String, "SpawnY") && DOF2_IsSet(String, "SpawnZ")) SetPlayerPos(playerid, ArquivoGangInt(playerid, "SpawnX"), ArquivoGangInt(playerid, "SpawnY"), ArquivoGangInt(playerid, "SpawnZ"));
		if(DOF2_IsSet(String, "Cor")) SetPlayerColor(playerid, ArquivoGangHex(playerid, "Cor"));
		format(String, sizeof(String), "Você é da gang '%s'", DOF2_GetString(str, "Nome"));
		SendClientMessage(playerid, ArquivoGangHex(playerid, "Cor"), String);
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(vehicleid == GangInfo[gangs][Carro1])
	{
		if(PlayerDados[playerid][Membro] != GangInfo[gangs][Carro1])
		{
		    RemovePlayerFromVehicle(playerid);
		    SendClientMessage(playerid, AZUL_CLARO, "Você não é dessa gang!");
		}
		return 1;
	}
	if(vehicleid == GangInfo[gangs][Carro2])
	{
		if(PlayerDados[playerid][Membro] != GangInfo[gangs][Carro2])
		{
		    RemovePlayerFromVehicle(playerid);
		    SendClientMessage(playerid, AZUL_CLARO, "Você não é dessa gang!");
		}
		return 1;
	}
	if(vehicleid == GangInfo[gangs][Carro3])
	{
		if(PlayerDados[playerid][Membro] != GangInfo[gangs][Carro3])
		{
		    RemovePlayerFromVehicle(playerid);
		    SendClientMessage(playerid, AZUL_CLARO, "Você não é dessa gang!");
		}
		return 1;
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(PlayerDados[playerid][CCarro1] == true)
	{
	    if(strlen(text) == strlen("aqui"))
	    {
	        DestroyVehicle(GangInfo[playerid][Carro1]);
	    	new Float:X,
				Float:Y,
				Float:Z,
				Float:A;
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, A);
			format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
			GangInfo[DOF2_GetInt(String, "Lider")][Carro1] = CreateVehicle(562, X, Y, Z, A, -1, -1, 15);
			PlayerDados[playerid][CCarro1] = false;
			SendClientMessage(playerid, VERDE_CLARO, "Carro criado com sucesso");
			DialogGang(playerid);
			return 0;
		}
		if(strlen(text) == strlen("cancelar"))
		{
		    PlayerDados[playerid][CCarro1] = false;
		    DialogGang(playerid);
		    return 0;
		}
		SendClientMessage(playerid, AMARELO, "Use 'aqui' ou 'cancelar' para criar o carro");
		return 0;
	}
	if(PlayerDados[playerid][CCarro2] == true)
	{
	    if(strlen(text) == strlen("aqui"))
	    {
	        DestroyVehicle(GangInfo[playerid][Carro2]);
	    	new Float:X,
				Float:Y,
				Float:Z,
				Float:A;
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, A);
			format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
			GangInfo[DOF2_GetInt(String, "Lider")][Carro2] = CreateVehicle(562, X, Y, Z, A, -1, -1, 15);
			PlayerDados[playerid][CCarro2] = false;
			SendClientMessage(playerid, VERDE_CLARO, "Carro criado com sucesso");
			DialogGang(playerid);
			return 0;
		}
		if(strlen(text) == strlen("cancelar"))
		{
		    PlayerDados[playerid][CCarro2] = false;
		    DialogGang(playerid);
		    return 0;
		}
		SendClientMessage(playerid, AMARELO, "Use 'aqui' ou 'cancelar' para criar o carro");
		return 0;
	}
	if(PlayerDados[playerid][CCarro3] == true)
	{
	    if(strlen(text) == strlen("aqui"))
	    {
	        DestroyVehicle(GangInfo[playerid][Carro3]);
	    	new Float:X,
				Float:Y,
				Float:Z,
				Float:A;
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, A);
			format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
			GangInfo[DOF2_GetInt(String, "Lider")][Carro3] = CreateVehicle(562, X, Y, Z, A, -1, -1, 15);
			PlayerDados[playerid][CCarro3] = false;
			SendClientMessage(playerid, VERDE_CLARO, "Carro criado com sucesso");
			DialogGang(playerid);
			return 0;
		}
		if(strlen(text) == strlen("cancelar"))
		{
		    PlayerDados[playerid][CCarro3] = false;
		    DialogGang(playerid);
		    return 0;
		}
		SendClientMessage(playerid, AMARELO, "Use 'aqui' ou 'cancelar' para criar o carro");
		return 0;
	}
	if(PlayerDados[playerid][LocalSpawn] == true)
	{
	    if(strlen(text) == strlen("aqui"))
	    {
	    	new Float:X,
				Float:Y,
				Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
			format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", DOF2_GetInt(String, "Lider"));
			DOF2_SetFloat(String, "SpawnX", X);
			DOF2_SetFloat(String, "SpawnY", Y);
			DOF2_SetFloat(String, "SpawnZ", Z);
			DOF2_SaveFile();
			PlayerDados[playerid][LocalSpawn] = false;
			DialogGang(playerid);
			SendClientMessage(playerid, VERDE_CLARO, "Local do Spawn setado com sucesso!");
			return 0;
		}
		if(strlen(text) == strlen("cancelar"))
		{
		    PlayerDados[playerid][LocalSpawn] = false;
		    DialogGang(playerid);
		    return 0;
		}
		SendClientMessage(playerid, AMARELO, "Use 'aqui' ou 'cancelar' para selecionar o local de spawn");
		return 0;
	}
	return 1;
}
		

CMD:gangcriar(playerid, params[])
{
	if(PlayerDados[playerid][Lider] > 0 || PlayerDados[playerid][Membro] > 0) return SendClientMessage(playerid, CINZA, "Você ja é de uma gang, use /gangsair para sair dela");
	ShowPlayerDialog(playerid, DIALOG_CRIAR, DIALOG_STYLE_INPUT, "{22750B}Criando uma gang", "{3BE60B}Escreva abaixo o Nome da\nGang que você deseja criar", "Criar", "Cancelar");
	return 1;
}

CMD:gangsair(playerid, params[])
{
	if(PlayerDados[playerid][Lider] > 0) return SendClientMessage(playerid, CINZA, "Você é lider de uma Gang, para encerra-la use /infogang!");
	if(PlayerDados[playerid][Membro] == 0) return SendClientMessage(playerid, CINZA, "Você não faz parte de nenhuma gang!");
	PlayerDados[playerid][Membro] = 0;
	return 1;
}

CMD:infogang(playerid, params[])
{
	if(PlayerDados[playerid][Lider] == 0) return SendClientMessage(playerid, CINZA, "Você não é lider de uma gang!");
	format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
	format(String, sizeof(String), "{0DD0DE}Menu da Gang %s", DOF2_GetString(String, "Nome"));
	ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String,"{25E01B}Nome da Gang\n{157310}Skin da Gang\n{34B8C7}Convidar\n{0DE4FC}Promover\n{FF0019}Demitir\n{FFEE00}Carro 1\n{FFEE00}Carro 2\n{FFEE00}Carro 3\n{FF00FF}Spawn\n{FFFFFF}Cor\n{FA460A}Tag\n{FA0A0A}Encerrar gang", "Ver", "Cancelar");
	return 1;
}

CMD:ga(playerid, params[])
{
	new Texto[128];
	if(sscanf(params, "s", Texto)) return SendClientMessage(playerid, CINZA, "Use /ga [texto] para mandar uma mensagem para todos da gang.");
    if(PlayerDados[playerid][Cargo] == 1) CargoNome = "Recruta";
	if(PlayerDados[playerid][Cargo] == 2) CargoNome = "Aprendiz";
	if(PlayerDados[playerid][Cargo] == 3) CargoNome = "Matador";
	if(PlayerDados[playerid][Cargo] == 4) CargoNome = "Profissional";
	if(PlayerDados[playerid][Cargo] == 5) CargoNome = "Poderoso Chefão";
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(PlayerDados[i][Membro] == PlayerDados[playerid][Membro])
	    {
			format(String, sizeof(String), "%s %s: %s", CargoNome, Nome(playerid), Texto);
			SendClientMessage(i, ArquivoGangHex(playerid, "Cor"), String);
		}
	}
	return 1;
}

CMD:membros(playerid, params[])
{
	SendClientMessage(playerid, ROXO, "Membros da Gang Online:");
	for(new i = 0; i < MAX_PLAYERS; i ++)
	{
	    if(PlayerDados[i][Membro] == PlayerDados[playerid][Membro])
	    {
	        if(PlayerDados[i][Cargo] == 1) CargoNome = "Recruta";
			if(PlayerDados[i][Cargo] == 2) CargoNome = "Aprendiz";
			if(PlayerDados[i][Cargo] == 3) CargoNome = "Matador";
			if(PlayerDados[i][Cargo] == 4) CargoNome = "Profissional";
			if(PlayerDados[i][Cargo] == 5) CargoNome = "Poderoso Chefão";
	        format(String, sizeof(String), "%s | %s (Cargo %d)", Nome(i), CargoNome, PlayerDados[i][Cargo]);
	        SendClientMessage(playerid, ArquivoGangHex(playerid, "Cor"), String);
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_CRIAR)
	{
		if(response)
		{
		    if(!strlen(inputtext))
				return SendClientMessage(playerid, VERMELHO_CLARO, "Você tem que digitar uma porra de um nome!"), ShowPlayerDialog(playerid, DIALOG_CRIAR, DIALOG_STYLE_INPUT, "{22750B}Criando uma gang", "{3BE60B}Escreva abaixo o Nome da\nGang que você deseja criar", "Criar", "Cancelar");
			format(String, sizeof(String), "{0DD0DE}Menu da Gang %s", inputtext);
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String, "{25E01B}Nome da Gang\n{157310}Skin da Gang\n{34B8C7}Convidar\n{0DE4FC}Promover\n{FF0019}Demitir\n{FFEE00}Carro 1\n{FFEE00}Carro 2\n{FFEE00}Carro 3\n{FF00FF}Spawn\n{FFFFFF}Cor\n{FA460A}Tag\n{FA0A0A}Encerrar gang", "Ver", "Cancelar");
			format(String, sizeof(String), "O Jogador {1B42E0}%s{00C2EC} Criou a Gang {1B42E0}%s{00C2EC}", Nome(playerid), inputtext);
			SendClientMessageToAll(AZUL_CLARO, String);
			gangs++;
			if(gangs > MAX_GANGS)
			{
			    format(String, sizeof(String), "O servidor ja possui o maximo de gangs ( %d ), Cominique um Admin.", MAX_GANGS);
			    SendClientMessage(playerid, CINZA, String);
			    return 0;
			}
            for(new t = 0; t < MAX_GANGS; t++)
            {
                format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", gangs);
                if(DOF2_FileExists(String))
                gangs++;
			}
			GangInfo[gangs][ID] = Gang[gangs];
			PlayerDados[playerid][Lider] = GangInfo[playerid][ID];
			format(StringGang, sizeof(StringGang), "LAGANGS/Gangs/%d.ini", gangs);
			DOF2_CreateFile(StringGang);
			DOF2_SetInt(StringGang, "ID", gangs);
			DOF2_SetString(StringGang, "Nome", inputtext);
			format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
			DOF2_SetInt(String, "Lider", gangs);
			DOF2_SetInt(String, "Membro", gangs);
			PlayerDados[playerid][Lider] = gangs;
			PlayerDados[playerid][Membro] = gangs;
			DOF2_SaveFile();
			SendClientMessage(playerid, AZUL_CLARO, "Lembre-se de alterar a COR da gang, caso contrario os membros ficaram da cor preta");
		}
		return 1;
	}
	if(dialogid == DIALOG_INFO)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
				format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
	            format(String, sizeof(String), "{FFFFFF}O Atual nome da Gang é {1BE032}%s{FFFFFF}\n\nEscreva o novo nome", DOF2_GetString(String, "Nome"));
	            ShowPlayerDialog(playerid, DIALOG_NOMEG, DIALOG_STYLE_INPUT, "Nome da Gang", String, "Mudar", "Cancelar");
	            return 1;
			}
			if(listitem == 1)
			{
			    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			    if(!DOF2_IsSet(String, "Skin"))
				{
					ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin da Gang", "{FFFFFF}O Skin da gang ainda não Está Definido\n\nDigite o ID da skin para defini-lo", "Definir", "Cancelar");
					return 1;
				}
				format(String, sizeof(String), "{FFFFFF}O Atual Skin da Gang é o {1BE032}%d{FFFFFF}\n\nColoque o novo ID abaixo", ArquivoGangInt(playerid, "Skin"));
				ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin da Gang", String, "Definir", "Cancelar");
				return 1;
			}
			if(listitem == 2)
			{
			    ShowPlayerDialog(playerid, DIALOG_CONVIDAR, DIALOG_STYLE_INPUT, "Convidando um jogador", "{FFFFFF}Digite abaixo o ID do jogador\nPara Convida-lo para sua Gang", "Convidar", "Cancelar");
			    return 1;
			}
			if(listitem == 3)
			{
			    ShowPlayerDialog(playerid, DIALOG_PROMOVER, DIALOG_STYLE_INPUT, "Promovendo um jogador", "{FFFFFF}Digite abaixo o ID do Jogador\nQue deseja promover", "Avancar", "Cancelar");
			    return 1;
			}
			if(listitem == 4)
			{
			    ShowPlayerDialog(playerid, DIALOG_DEMITIR, DIALOG_STYLE_INPUT, "Demitindo um Membro", "{FFFFFF}Digite abaixo o ID do jogador que\ndeseja demitir", "Demitir", "Cancelar");
			    return 1;
			}
			if(listitem == 5)
			{
			    ShowPlayerDialog(playerid, DIALOG_CARROS, DIALOG_STYLE_MSGBOX, "Criando Carro 1", "{FFDD00}Vá até o local que você deseja criar o\nVeículo e digite 'aqui' sem aspas", "Ok", "Cancelar");
				PlayerDados[playerid][CCarro1] = true;
				return 1;
			}
			if(listitem == 6)
			{
			    ShowPlayerDialog(playerid, DIALOG_CARROS, DIALOG_STYLE_MSGBOX, "Criando Carro 2", "{FFDD00}Vá até o local que você deseja criar o\nVeículo e digite 'aqui' sem aspas", "Ok", "Cancelar");
				PlayerDados[playerid][CCarro2] = true;
				return 1;
			}
			if(listitem == 7)
			{
			    ShowPlayerDialog(playerid, DIALOG_CARROS, DIALOG_STYLE_MSGBOX, "Criando Carro 3", "{FFDD00}Vá até o local que você deseja criar o\nVeículo e digite 'aqui' sem aspas", "Ok", "Cancelar");
				PlayerDados[playerid][CCarro3] = true;
				return 1;
			}
			if(listitem == 8)
			{
			    ShowPlayerDialog(playerid, DIALOG_SPAWN, DIALOG_STYLE_MSGBOX, "Local do Spawn", "{FF00E1}Vá até o local onde você deseja\nque seja o Spawn da sua gang e\ndigite 'aqui' sem aspas", "Ok", "Cancelar");
				PlayerDados[playerid][LocalSpawn] = true;
				return 1;
			}
			if(listitem == 9)
			{
			    ShowPlayerDialog(playerid, DIALOG_COR, DIALOG_STYLE_LIST, "{FFFFFF}Cor do Nick dos Membros", "{FF0505}Vermelho \n{FF05FB}Rosa \n{0D05FF}Azul \n{05FFE2}Azul Claro \n{048706}Verde \n{0DFF05}Verde Claro \n{FFFF05}Amarelo \n{FF9705}Laranjado \n{000000}Preto \n{FFFFFF}Branco", "Mudar", "Cancelar");
			    return 1;
			}
			if(listitem == 10)
			{
			    ShowPlayerDialog(playerid, DIALOG_TAG, DIALOG_STYLE_INPUT,"Tag da Gang", "{37C90E}Digite Abaixo a tag da sua gang\nLembre-se de utilizar as chaves []\n\nEx: [LA]\n", "Setar", "Cancelar");
			    return 1;
			}
			if(listitem == 11)
			{
			    ShowPlayerDialog(playerid, DIALOG_ENCERRAR, DIALOG_STYLE_MSGBOX, "{FFFFFF}Encerrando a gang", "{FC3236}Tem certeza que deseja acabar\ncom a sua Gang?", "Sim", "Não");
			    return 1;
			}
		}
	}
	if(dialogid == DIALOG_ENCERRAR)
	{
	    if(response)
	    {
	        format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", GangPlayer(playerid));
	        DOF2_RemoveFile(String);
	        for(new i = 0; i < MAX_PLAYERS; i++)
	        {
	            if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider])
	            {
	            	new str[100];
					format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	            	format(String, sizeof(String), "O Lider {048706}%s{0DFF05} encerrou a Gang {048706}%s{0DFF05}, Boa sorte na Vida a todos.", Nome(playerid), DOF2_GetString(str, "Nome"));
	            	AvisoLider(playerid, String);
	            	DOF2_RemoveFile(str);
	            	format(str, sizeof(str), "LAGANGS/Players/%s.ini", Nome(i));
	            	DOF2_SetInt(str, "Lider", 0);
	            	DOF2_SetInt(str, "Membro", 0);
	            	DOF2_SetInt(str, "Cargo", 0);
				}
			}
		}
		if(!response) DialogGang(playerid);
	}
	if(dialogid == DIALOG_TAG)
	{
	    if(response)
	    {
	        if(!strlen(inputtext))
	        {
	            ShowPlayerDialog(playerid, DIALOG_TAG, DIALOG_STYLE_INPUT,"Tag da Gang", "{FFFFFF}Digite Abaixo a tag da sua gang\nLembre-se de utilizar as chaves []\n\nEx: [LA]\n", "Setar", "Cancelar");
	            SendClientMessage(playerid, CINZA, "Escreva alguma coisa ou clique em cancelar");
	            return 0;
			}
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
			    if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider])
			    {
					new NomeA[24];
					GetPlayerName(i, NomeA, 24);
					format(String, sizeof(String), "LAGANGS/Players/%s.ini", NomeA);
					DOF2_RemoveFile(String);
					format(String, sizeof(String), "%s%s", inputtext, NomeA);
					SetPlayerName(i, String);
					format(String, sizeof(String), "LAGANGS/Players/%s.ini", NomeA);
					DOF2_CreateFile(String);
					DOF2_SetInt(String, "Lider", PlayerDados[playerid][Lider]);
					DOF2_SetInt(String, "Membro", PlayerDados[playerid][Membro]);
					DOF2_SetInt(String, "Cargo", PlayerDados[playerid][Cargo]);
					format(String, sizeof(String), "O Lider da Gang {048706}%s{0DFF05} Mudou a tag dos membros da gang para {048706}%s{0DFF05}", Nome(playerid), inputtext);
					SendClientMessage(i, VERDE_CLARO, String);
				}
			}
			format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", GangPlayer(playerid));
			DOF2_SetString(String, "Tag", inputtext);
		}
		if(!response) DialogGang(playerid);
	}
	if(dialogid == DIALOG_COR)
	{
	    if(response)
	    {
	        if(listitem == 0) return SetarCor(playerid, 0xFF050596, "O Lider da gang alterou a cor de todos os Membros para Vermelho");
	        if(listitem == 1) return SetarCor(playerid, 0xFF05FB96, "O Lider da gang alterou a cor de todos os Membros para Rosa");
	        if(listitem == 2) return SetarCor(playerid, 0x0D05FF96, "O Lider da gang alterou a cor de todos os Membros para Azul");
	        if(listitem == 3) return SetarCor(playerid, 0x05FFE296, "O Lider da gang alterou a cor de todos os Membros para Azul Claro");
	        if(listitem == 4) return SetarCor(playerid, 0x04870696, "O Lider da gang alterou a cor de todos os Membros para Verde");
	        if(listitem == 5) return SetarCor(playerid, 0x0DFF0596, "O Lider da gang alterou a cor de todos os Membros para Verde Claro");
	        if(listitem == 6) return SetarCor(playerid, 0xFFFF0596, "O Lider da gang alterou a cor de todos os Membros para Amarelo");
	        if(listitem == 7) return SetarCor(playerid, 0xFF970596, "O Lider da gang alterou a cor de todos os Membros para Laranjado");
	        if(listitem == 8) return SetarCor(playerid, 0x00000096, "O Lider da gang alterou a cor de todos os Membros para Preto");
	        if(listitem == 9) return SetarCor(playerid, 0xFFFFFF96, "O Lider da gang alterou a cor de todos os Membros para Branco");
		}
		if(!response) DialogGang(playerid);
	}
	if(dialogid == DIALOG_CARROS)
	{
	    if(!response)
		{
			DialogGang(playerid);
			PlayerDados[playerid][CCarro1] = false;
			PlayerDados[playerid][CCarro2] = false;
			PlayerDados[playerid][CCarro3] = false;
		}
	}
	if(dialogid == DIALOG_SPAWN)
	{
	    if(!response)
	    {
	        DialogGang(playerid);
	        PlayerDados[playerid][LocalSpawn] = false;
		}
	}
	if(dialogid == DIALOG_DEMITIR)
	{
	    if(response)
	    {
            new str1[128];
	        format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	        format(str1, sizeof(str1), "LAGANGS/Players/%s.ini", Nome(strval(inputtext)));
	        if(!IsPlayerConnected(strval(inputtext)))
	        {
	            SendClientMessage(playerid, CINZA, "Jogador Offline!");
	            ShowPlayerDialog(playerid, DIALOG_PROMOVER, DIALOG_STYLE_INPUT, "Demitindo um Membro", "{FFFFFF}Digite abaixo o ID do jogador que\ndeseja demitir", "Demitir", "Cancelar");
				return 1;
			}
	        if(DOF2_GetInt(str1, "Membro") != DOF2_GetInt(String, "Lider"))
	        {
	            SendClientMessage(playerid, VERMELHO, "Você só pode demitir um jogador da sua gang!");
	            ShowPlayerDialog(playerid, DIALOG_DEMITIR, DIALOG_STYLE_INPUT, "Demitindo um Membro", "{FFFFFF}Digite abaixo o ID do jogador que\ndeseja demitir", "Demitir", "Cancelar");
	            return 1;
			}
	        format(String, sizeof(String), "O Lider Demitiu o Jogador {3BEDC7}%s{008040} da Gang!", Nome(strval(inputtext)));
			AvisoLider(playerid, String);
	        PlayerDados[strval(inputtext)][Membro] = 0;
	        PlayerDados[strval(inputtext)][Lider] = 0;
	        PlayerDados[strval(inputtext)][Cargo] = 0;
	        SetPlayerSkin(strval(inputtext), 0);
		}
		if(!response) return DialogGang(playerid);
	}
	if(dialogid == DIALOG_PROMOVER)
	{
	    if(response)
	    {
	        new str1[128];
	        format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	        format(str1, sizeof(str1), "LAGANGS/Players/%s.ini", Nome(strval(inputtext)));
	        if(!IsPlayerConnected(strval(inputtext)))
	        {
	            SendClientMessage(playerid, CINZA, "Jogador Offline!");
	            ShowPlayerDialog(playerid, DIALOG_PROMOVER, DIALOG_STYLE_INPUT, "Promovendo um jogador", "Digite abaixo o ID do Jogador\nQue deseja promover", "Avancar", "Cancelar");
				return 1;
			}
	        if(DOF2_GetInt(str1, "Membro") != DOF2_GetInt(String, "Lider"))
	        {
	            SendClientMessage(playerid, VERMELHO, "Você só pode promover um jogador da sua gang!");
	            ShowPlayerDialog(playerid, DIALOG_PROMOVER, DIALOG_STYLE_INPUT, "Promovendo um jogador", "Digite abaixo o ID do Jogador\nQue deseja promover", "Avancar", "Cancelar");
	            return 1;
			}
			IdPromovido = strval(inputtext);
			format(String, sizeof(String), "{FFFFFF}Digite abaixo o cargo que\nvocê deseja dar ao jogador {3BEDC7}ID %d", IdPromovido);
			ShowPlayerDialog(playerid, DIALOG_PROMOVER2, DIALOG_STYLE_INPUT, "Promovendo um Jogador", String, "Promover", "Voltar");
		}
		if(!response) return DialogGang(playerid);
		return 1;
	}
	if(dialogid == DIALOG_PROMOVER2)
	{
	    if(response)
	    {
	        if(strval(inputtext) > 5 || strval(inputtext) < 1)
	        {
	            SendClientMessage(playerid, VERMELHO, "O cargo Máximo é 5 e o mínimo é 1!");
	            format(String, sizeof(String), "Digite abaixo o cargo que\nvocê deseja dar ao jogador ID {3BEDC7}%d", IdPromovido);
				ShowPlayerDialog(playerid, DIALOG_PROMOVER2, DIALOG_STYLE_INPUT, "Promovendo um Jogador", String, "Promover", "Voltar");
				return 0;
			}
			for(new i = 0; i < MAX_PLAYERS; i++)
	        {
	            if(PlayerDados[i][Membro] == PlayerDados[playerid][Membro])
	            {
	                format(String, sizeof(String), "O Lider Promoveu o jogador {3BEDC7}%s{38FF06} para Cargo {3BEDC7}%d", Nome(IdPromovido), strval(inputtext));
	                SendClientMessage(i, VERDE_CLARO, String);
				}
			}
			PlayerDados[IdPromovido][Cargo] = strval(inputtext);
			SalvarDados(IdPromovido);
		}
		if(!response) return DialogGang(playerid);
	}
	if(dialogid == DIALOG_CONVIDAR)
	{
	    if(response)
	    {
	        if(!strlen(inputtext))
	        {
	            SendClientMessage(playerid, VERMELHO_CLARO, "Digite um ID Válido!");
	            ShowPlayerDialog(playerid, DIALOG_CONVIDAR, DIALOG_STYLE_INPUT, "Convidando um jogador", "Digite abaixo o ID do jogador\nPara Convida-lo para sua Gang", "Convidar", "Cancelar");
				return 1;
			}
		 	if(!IsPlayerConnected(strval(inputtext)))
		 	{
				SendClientMessage(playerid, VERMELHO_CLARO, "Jogador Offline");
				ShowPlayerDialog(playerid, DIALOG_CONVIDAR, DIALOG_STYLE_INPUT, "Convidando um jogador", "Digite abaixo o ID do jogador\nPara Convida-lo para sua Gang", "Convidar", "Cancelar");
				return 1;
			}
			new str[256];
			format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			format(String, sizeof(String), "{FFFFFF}Você está sendo convidado pelo Lider {3BEDC7}%s{FFFFFF}\nPara participar da gang {3BEDC7}%s", Nome(playerid), DOF2_GetString(str, "Nome"));
			ShowPlayerDialog(strval(inputtext), DIALOG_CONVIDADO, DIALOG_STYLE_MSGBOX, "Convidado para Gang", String, "Aceitar", "Recusar");
			format(String, sizeof(String), "Jogador %s [ID: %d] Convidado, aguarde a resposta", Nome(strval(inputtext)), strval(inputtext));
			SendClientMessage(playerid, AZUL_CLARO, String);
			IdConvidou = playerid;
			IdGangC = DOF2_GetInt(str, "ID");
		}
		if(!response) return DialogGang(playerid);
		return 1;
	}
	if(dialogid == DIALOG_CONVIDADO)
	{
	    if(response)
	    {
	        PlayerDados[playerid][Membro] = IdGangC;
			for(new i; i < MAX_PLAYERS; i++)
			{
			    if(PlayerDados[i][Membro] == PlayerDados[playerid][Membro])
			    {
			        format(String, sizeof(String), "{3BED3E}O Jogador {3BEDC7}%s{3BED3E} aceitou o convite de {3BEDC7}%s{3BED3E} e é o mais novo membro da gang", Nome(playerid), Nome(IdConvidou));
			        SendClientMessage(i, VERDE_CLARO, String);
				}
			}
		}
		if(!response)
		{
			format(String, sizeof(String), "O Jogador {3BEDC7}%s{3BED3E} Recusou seu convite", Nome(playerid));
			SendClientMessage(IdConvidou, VERDE_CLARO, String);
		}
	}
	if(dialogid == DIALOG_SKIN)
	{
	    if(response)
	    {
			if(!strlen(inputtext))
			{
			    SendClientMessage(playerid, VERMELHO_CLARO, "Digite um numero válido!");
                format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			    if(!DOF2_IsSet(String, "Skin"))
				{
					ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin da Gang", "O Skin da gang ainda não Está Definido\n\nDigite o ID da skin para defini-lo", "Definir", "Cancelar");
					return 1;
				}
				format(String, sizeof(String), "{FFFFFF}O Atual Skin da Gang é o {1BE032}%d{FFFFFF}\n\nColoque o novo ID abaixo",ArquivoGangInt(playerid, "Skin"));
				ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin da Gang", String, "Definir", "Cancelar");
				return 1;
			}
			if(strval(inputtext) > 299)
			{
			    SendClientMessage(playerid, VERMELHO_CLARO, "Numero maximo é 299!");
                format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			    if(!DOF2_IsSet(String, "Skin"))
				{
					ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin da Gang", "O Skin da gang ainda não Está Definido\n\nDigite o ID da skin para defini-lo", "Definir", "Cancelar");
					return 1;
				}
				format(String, sizeof(String), "{FFFFFF}O Atual Skin da Gang é o {1BE032}%d{FFFFFF}\n\nColoque o novo ID abaixo",ArquivoGangInt(playerid, "Skin"));
				ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, "Skin da Gang", String, "Definir", "Cancelar");
				return 1;
			}
	        format(String, sizeof(String), "O Lider da Gang Mudou a Skin De todos os membros para a {1BE032}%d{FFFFFF}", strval(inputtext));
	        AvisoLider(playerid, String);
	        DOF2_SetInt(IdGang(playerid), "Skin", strval(inputtext));
	        for(new i = 0; i < MAX_PLAYERS; i++)
	        {
				if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider])
				{
				    SetPlayerSkin(i, strval(inputtext));
				}
			}
			DialogGang(playerid);
		}
		if(!response)
		{
		    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			format(String, sizeof(String), "{0DD0DE}Menu da Gang %s", DOF2_GetString(String, "Nome"));
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String,"{25E01B}Nome da Gang\n{157310}Skin da Gang\n{34B8C7}Convidar\n{0DE4FC}Promover\n{FF0019}Demitir\n{FFEE00}Carro 1\nCarro 2\nCarro 3\n{FF00FF}Spawn\n{FFFFFF}Cor\n{FA460A}Tag\n{FA0A0A}Encerrar gang", "Ver", "Cancelar");
	    }
	}
	if(dialogid == DIALOG_NOMEG)
	{
	    if(response)
	    {
	        if(!strlen(inputtext))
			{
				SendClientMessage(playerid, VERMELHO_CLARO, "Nome Invalido");
				format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
				format(String, sizeof(String), "{FFFFFF}O Atual nome da Gang é {1BE032}%s{FFFFFF}\n\nEscreva o novo nome", DOF2_GetString(String, "Nome"));
	            ShowPlayerDialog(playerid, DIALOG_NOMEG, DIALOG_STYLE_INPUT, "Nome da Gang", String, "Mudar", "Cancelar");
	            return 0;
			}
	        format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
	        DOF2_SetString(String, "Nome", inputtext);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
			    if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider])
			    {
			        format(String, sizeof(String), "O Lider {3B65ED}%s{38FF06} Mudou o nome da Gang para {3B65ED}%s", Nome(playerid), inputtext);
			        SendClientMessage(i, VERDE_CLARO, String);
				}
			}
			format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			format(String, sizeof(String), "{0DD0DE}Menu da Gang %s", DOF2_GetString(String, "Nome"));
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String,"{25E01B}Nome da Gang\n{157310}Skin da Gang\n{34B8C7}Convidar\n{0DE4FC}Promover\n{FF0019}Demitir\n{FFEE00}Carro 1\n{FFEE00}Carro 2\n{FFEE00}Carro 3\n{FF00FF}Spawn\n{FFFFFF}Cor\n{FA460A}Tag\n{FA0A0A}Encerrar gang", "Ver", "Cancelar");
		}
		if(!response)
		{
		    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
			format(String, sizeof(String), "{0DD0DE}Menu da Gang %s", DOF2_GetString(String, "Nome"));
			ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String,"{25E01B}Nome da Gang\n{157310}Skin da Gang\n{34B8C7}Convidar\n{0DE4FC}Promover\n{FF0019}Demitir\n{FFEE00}Carro 1\n{FFEE00}Carro 2\n{FFEE00}Carro 3\n{FF00FF}Spawn\n{FFFFFF}Cor\n{FA460A}Tag\n{FA0A0A}Encerrar gang", "Ver", "Cancelar");
		}
	}
	return 1;
}

stock Nome(playerid)
{
	new pname[24];
	GetPlayerName(playerid, pname, 24);
	return pname;
}

stock ContaExiste(playerid)
{
	format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	return DOF2_FileExists(String);
}
	
stock IdGang(playerid)
{
	new StringNome[100];
    format(StringNome, sizeof(StringNome), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
    return StringNome;
}

stock ArquivoGangInt(playerid, linha[])
{
 	new str[100];
	format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	return DOF2_GetInt(str, linha);
}

stock ArquivoGangHex(playerid, linha[])
{
 	new str[100];
	format(str, sizeof(str), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Membro]);
	return DOF2_GetHex(str, linha);
}

stock AvisoLider(playerid, mensagem[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider] || PlayerDados[i][Lider] == PlayerDados[playerid][Lider])
	    {
	    	SendClientMessage(i, VERDE_CLARO, mensagem);
		}
	}
	return 1;
}

stock DialogGang(playerid)
{
    format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", PlayerDados[playerid][Lider]);
	format(String, sizeof(String), "{0DD0DE}Menu da Gang %s", DOF2_GetString(String, "Nome"));
	ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_LIST, String,"{25E01B}Nome da Gang\n{157310}Skin da Gang\n{34B8C7}Convidar\n{0DE4FC}Promover\n{FF0019}Demitir\n{FFEE00}Carro 1\n{FFEE00}Carro 2\n{FFEE00}Carro 3\n{FF00FF}Spawn\n{FFFFFF}Cor\n{FA460A}Tag\n{FA0A0A}Encerrar gang", "Ver", "Cancelar");
	return 1;
}

stock SalvarDados(playerid)
{
    format(String, sizeof(String), "LAGANGS/Players/%s.ini", Nome(playerid));
	DOF2_SetInt(String, "Lider", PlayerDados[playerid][Lider]);
	DOF2_SetInt(String, "Membro", PlayerDados[playerid][Membro]);
	DOF2_SetInt(String, "Cargo", PlayerDados[playerid][Cargo]);
	return 1;
}

stock SetarCor(playerid, cor, mensagem[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(PlayerDados[i][Membro] == PlayerDados[playerid][Lider])
	    {
	        SetPlayerColor(i, cor);
	        SendClientMessage(i, cor, mensagem);
		}
	}
	format(String, sizeof(String), "LAGANGS/Gangs/%d.ini", GangPlayer(playerid));
	DOF2_SetHex(String, "Cor", cor);
	return 1;
}

stock GangPlayer(playerid)
{
	new str[128];
	format(str, sizeof(str), "LAGANGS/Players/%s.ini", Nome(playerid));
	return DOF2_GetInt(str, "Membro");
}









