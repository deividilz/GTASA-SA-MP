// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

#include <a_samp>
#pragma tabsize 0
#include "../include/gl_common.inc"
#pragma tabsize 0

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

#define _CHANGE_NAME_BEFORE_KICK        true

stock
        bool:   bIllegalPlayer  [ MAX_PLAYERS ] = false;

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

new PMTick[MAX_PLAYERS];
new HAntiFlood[MAX_PLAYERS],HAntiFlood2[MAX_PLAYERS];
new BloquearPMsDe[MAX_PLAYERS] = -1;
new bool:Trollado[MAX_PLAYERS];
#define Vred 0xFF0000AA
#define ADMINFS_MESSAGE_COLOR 0xFF444499
#define PM_INCOMING_COLOR     0xFFDC00FF
#define PM_OUTGOING_COLOR     0xFFDC00FF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_LIMON	0x00FF00FF
#define COLOR_ORANGE	0xFF9900AA
#define COLOUR_ERRO 0xFF0000FF
#define COLOUR_INFORMACAO 0x00FF00FF
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

new DataStatus[100];
new BPM[MAX_PLAYERS];
new REPEATS[MAX_PLAYERS];
new VISITAS,MORTES,DIVULGACOES,COMANDOS,MENSAGENS,PMS,FLOODKICKS,MSINVALIDAS,FLOODREPEATS,TOTALREPEATS;
new CAIDOS,SAIDAS,KICKBAN,VEICULOSUSADOS;
new LastText[MAX_PLAYERS][129];
new PlayerDivulgacoesIP[MAX_PLAYERS];
new UltimaDivulgacaoStamp[MAX_PLAYERS];

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

new CrashNicks[][MAX_PLAYER_NAME]  =
{
"com1", "com2", "com3", "com4", "com5", "com6", "com7", "com8", "com9",
"lpt1", "lpt2", "lpt3", "lpt4", "lpt5", "lpt6", "lpt7", "lpt8", "lpt9",
"nul", "clock$", "aux", "prn", "con"
};

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

new NicksProibidosGlobal[][MAX_PLAYER_NAME]  =
{
"ADM", "Admin", "[DONO]", "A.D.M", "ANN", "HAX4"
};

public OnPlayerDeath(playerid, killerid, reason){
MORTES++;return 1;}

public OnPlayerStateChange(playerid, newstate, oldstate){
if(newstate == PLAYER_STATE_DRIVER){VEICULOSUSADOS++;}}

stock IsAColorHackText(text[])
{
new bool:state1,bool:state2;
if(strfind(text, "{", false) != -1) state1 = true; else state1 = false;
if(strfind(text, "}", false) != -1) state2 = true; else state2 = false;
if(state1 == true && state2 == true) return 1;
return 0;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

dcmd_trollar(playerid,params[]){
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não tem permissão para isso");
if(!strlen(params)) return SendClientMessage(playerid, COLOUR_ERRO,"USO: /trollar <ID>");
if(!IsNumeric(params)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: ID Invalida");
new param=strval(params);
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) if(CallRemoteFunction("GetPlayerAdminLevel","i",param) > 1) return SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você não pode trollar um administrador!");
if(!IsPlayerConnected(param)) return SendClientMessage(playerid,COLOUR_ERRO,"ERRO: Jogador não conectado");
CallRemoteFunction("CMDMessageToAdmins","is",playerid,"TROLLAR");
new string[140], pname[MAX_PLAYER_NAME];
GetPlayerName(param, pname, sizeof(pname));
if(Trollado[param] == false){
format(string, sizeof(string), "[INFO]: %s (%i): não conseguirá mandar mensagens no chat nem comandos!", pname, param);
Trollado[param] = true;
}else{
format(string, sizeof(string), "[INFO]: %s (%i): enviará mensagens no chat e comandos normalmente", pname, param);
Trollado[param] = false;}
SendClientMessage(playerid, COLOUR_INFORMACAO, string);
return 1;}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

dcmd_bloquear(playerid,params[]) {

	if(!strlen(params))
	{
		if(BloquearPMsDe[playerid] > -1){
		BloquearPMsDe[playerid] = -1;
		SendClientMessage(playerid, COLOR_LIMON, "[INFO]: Você desbloqueou o player");
		return 1;}

	SendClientMessage(playerid,Vred, "USO: /bloquear <id>");
	return 1;
	}


	new id = strval(params);
	if(!IsNumeric(params)){id = ReturnPlayerID(params);}
	if(!IsPlayerConnected(id)) {SendClientMessage(playerid,Vred,"[ERRO]: O ID ou nick digitado não está online");return 1;}
	if(id == playerid) return SendClientMessage(playerid,Vred,"[ERRO]: Você não pode bloquear você mesmo");

	new pname[30],str[128];
	GetPlayerName(id, pname, sizeof(pname));
	format(str, sizeof(str), "[INFO]: Você bloqueou PM's de: {FF9900}%s (%i) {00FF00}- Para desbloquear: {FF9900}/bloquear{00FF00} (novamente)",pname,id);
	SendClientMessage(playerid, COLOR_LIMON, str);
	BloquearPMsDe[playerid] = id;



	return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnPlayerText(playerid,text[])
{

if(Trollado[playerid] == true) return 0;

//AntiColor
if(IsAColorHackText(text)){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Os códigos de cores são bloqueados aqui!");
return 0;}

// ANTI-BUG
if (strlen(text) > 240){return 1;}

//ANTI-BOTZ
if(strfind(text, "NIEX.org", false) != -1){
Kick(playerid);
return 0;}


//ANTI-IP
new ver_string[128];
if(TimeStamp()-UltimaDivulgacaoStamp[playerid]>60){PlayerDivulgacoesIP[playerid] = 0;}
strmid(ver_string, text, 0, strlen(text));
if(FindIpPattern(playerid,ver_string)){
PlayerDivulgacoesIP[playerid]++;
if(PlayerDivulgacoesIP[playerid] > 1){
CallRemoteFunction("KickPlayerEx","is",playerid,"Tentou divulgar IP");
DIVULGACOES++;}else{
SendClientMessage(playerid, COLOR_YELLOW, "========================== [AVISO] ==========================");
SendClientMessage(playerid, COLOR_YELLOW, "O servidor detectou uma divulgação de IP em sua mensagem");
SendClientMessage(playerid, COLOR_YELLOW, "Se continuar a digitar esta mensagem, poderá ser kickado.");
SendClientMessage(playerid, COLOR_YELLOW, "===========================================================");
UltimaDivulgacaoStamp[playerid] = TimeStamp();
return 0;}return 0;}




//ANTI-REPETIR
//static LastText[MAX_PLAYERS][128];
if(strfind(LastText[playerid], text, false) != -1){
if(strlen(text) == strlen(LastText[playerid])){
FLOODREPEATS++;
SendClientMessage(playerid, COLOR_YELLOW, "[AVISO]: Pare de repetir no chat!"); return 0;}}

//KICKAR FLOOD REPETIDO
if(TimeStamp()-HAntiFlood2[playerid]>20){REPEATS[playerid] = 0;}

if(strlen(text) > 30){
if(strlen(LastText[playerid]) < strlen(text)){
if(strfind(text, LastText[playerid], false) != -1){TOTALREPEATS++;
if(REPEATS[playerid] == 0){
REPEATS[playerid]++;
SendClientMessage(playerid, COLOR_YELLOW, "[AVISO]: Pare de repetir no chat! Você pode ser kickado!");}else{
CallRemoteFunction("KickPlayerEx","is",playerid,"Flood/Repetindo no chat");
FLOODKICKS++;
return 0;}
}}}//}

//KICKAR FALADORES DE NADA 2
if(strlen(text) == 1){
if(strfind(text, " ", false) != -1){
MSINVALIDAS++;
SendClientMessage(playerid, COLOR_YELLOW, "[AVISO]: Mensagem inválida.");
return 0;}}

//KICKAR FALADORES DE NADA 4
if(strlen(text) == 2){
if(strfind(text, "  ", false) != -1){
MSINVALIDAS++;
SendClientMessage(playerid, COLOR_YELLOW, "[AVISO]: Mensagem inválida.");
return 0;}}

//KICKAR FALADORES DE NADA 3
if(strlen(text) == 3){
if(strfind(text, "   ", false) != -1){
MSINVALIDAS++;
SendClientMessage(playerid, COLOR_YELLOW, "[AVISO]: Mensagem inválida.");
return 0;}}

//KICKAR FALADORES DE NADA 4
if(strlen(text) == 4){
if(strfind(text, "    ", false) != -1){
MSINVALIDAS++;
SendClientMessage(playerid, COLOR_YELLOW, "[AVISO]: Mensagem inválida.");
return 0;}}

//KICKAR EXCESSO DE ESPAÇOS
if(strfind(text, "     ", false) != -1){
MSINVALIDAS++;
SendClientMessage(playerid, COLOR_YELLOW, "[AVISO]: Excesso de espaços na mensagem.");
return 0;}


strmid(LastText[playerid], text, 0, strlen(text), sizeof(LastText[]));
HAntiFlood2[playerid] = TimeStamp();
MENSAGENS++;
return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnPlayerCommandText(playerid, cmdtext[])
{

if(IsAColorHackText(cmdtext)){SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Os códigos de cores são bloqueados aqui!");return 1;}

if(Trollado[playerid] == true) return 1;

// ANTI-BUFFER_OVERFLOW
if (strlen(cmdtext) > 240){return 1;}

//ANTI-FLOOD NOS COMANDOS
if(TimeStamp()-HAntiFlood[playerid]<1){return 1;}HAntiFlood[playerid] = TimeStamp();

//PROCESSAMENTO DE COMANDOS
new cmd[128];
new	tmp[128];
new pName[MAX_PLAYER_NAME+1];
new iName[MAX_PLAYER_NAME+1];
new	idx;
cmd = strtok(cmdtext, idx);

dcmd(bloquear,8,cmdtext);
dcmd(trollar,7,cmdtext);


COMANDOS++;

if(strcmp("/upm", cmd, true) == 0){
new str_pm[128];
GetPVarString(playerid, "UltimaPM", str_pm, 128);
if (strlen(str_pm) < 3) return SendClientMessage(playerid,Vred,"[ERRO]: Você ainda não recebeu PMs");
SendClientMessage(playerid, COLOR_LIMON, "[INFO]: Última PM Recebida:");
SendClientMessage(playerid, PM_INCOMING_COLOR, str_pm);
return 1;}


//COMANDO PARA BLOQUEAR PMs
if(strcmp("/bpm", cmd, true) == 0){
if(BPM[playerid] == 0){
BPM[playerid] = 1;
SendClientMessage(playerid, COLOR_LIMON, "[INFO]: Recebimento de PMs bloqueado");
}else{
BPM[playerid] = 0;
SendClientMessage(playerid, COLOR_LIMON, "[INFO]: Recebimento de PMs liberado");
}return 1;}

if(strcmp(cmd, "/svstats", true) == 0) {
//if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 1) return SendClientMessage(playerid,Vred,"ERRO: Voce nao tem permissao para isso.");
new svstats1[128],svstats2[128],svstats3[128],svstats4[128],svstats5[128],svstats6[128];
format(svstats1, sizeof(svstats1), "Total de visitas: %i - Total de mortes: %i",VISITAS,MORTES);
format(svstats2, sizeof(svstats2), "Divulgações de IP: %i - Mensagens privadas: %i",DIVULGACOES,PMS);
format(svstats3, sizeof(svstats3), "Linhas de chat: %i - Comandos usados: %i - Veículos usados: %i",MENSAGENS,COMANDOS,VEICULOSUSADOS);
format(svstats4, sizeof(svstats4), "Kicks por flood/repeat: %i - Mensagens inválidas digitadas: %i",FLOODKICKS,MSINVALIDAS);
format(svstats5, sizeof(svstats5), "Repetições no chat bloqueadas: %i - Total de repetições de flood: %i",FLOODREPEATS,TOTALREPEATS);
format(svstats6, sizeof(svstats6), "Kickados/Banidos: %i - Caídos: %i - Saíram normalmente: %i",KICKBAN,CAIDOS,SAIDAS);
SendClientMessage(playerid, COLOR_LIMON, "");
SendClientMessage(playerid, COLOR_LIMON, "Status geral e contadores do server:");
SendClientMessage(playerid, COLOR_ORANGE, svstats1);
SendClientMessage(playerid, COLOR_ORANGE, svstats2);
SendClientMessage(playerid, COLOR_ORANGE, svstats3);
SendClientMessage(playerid, COLOR_ORANGE, svstats4);
SendClientMessage(playerid, COLOR_ORANGE, svstats5);
SendClientMessage(playerid, COLOR_ORANGE, svstats6);
SendClientMessage(playerid, COLOR_LIMON, DataStatus);
SendClientMessage(playerid, COLOR_LIMON, "");
return 1;}

if(strcmp(cmd, "/clearstats", true) == 0) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 5) return SendClientMessage(playerid,Vred,"[ERRO]: Você nao tem permissão para isso");
ClearSVStats();
SendClientMessage(playerid, COLOR_LIMON, "[INFO]: Server status limpo!");
return 1;}

//COMANDO PM -----------------------------------------------------------------------------------------------------------
if(strcmp("/pm", cmd, true) == 0 || strcmp("/sms", cmd, true) == 0 || strcmp("/mp", cmd, true) == 0 || strcmp("/msg", cmd, true) == 0){
if(CallRemoteFunction("GetPlayerRegisteredAndLogged","i",playerid) != 1){SendClientMessage(playerid, COLOUR_ERRO, "[ERRO]: Para usar este comando você deve estar registrado e logado"); return 1;}
if(TimeStamp()-PMTick[playerid] < 3){
SendClientMessage(playerid,COLOUR_ERRO,"[ERRO]: Você só pode enviar uma PM a cada 3 segundos");
PMTick[playerid] = TimeStamp();
return 1;}
new Message[128];
new gMessage[128];
tmp = strtok(cmdtext,idx);if(!strlen(tmp) || strlen(tmp) > 5) {
SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"Uso: /pm [ID] [Mensagem]");return 1;}
new id = strval(tmp);gMessage = strrest(cmdtext,idx);if(!strlen(gMessage)) {
SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"Uso: /pm [ID] [Mensagem]");return 1;}
if(!IsNumeric(tmp)){id = ReturnPlayerID(tmp);}
if(!IsPlayerConnected(id)) {SendClientMessage(playerid,Vred,"[ERRO]: O ID ou nick digitado não está online");return 1;}
if(playerid != id) {GetPlayerName(id,iName,sizeof(iName));
GetPlayerName(playerid,pName,sizeof(pName));
format(Message,sizeof(Message),"** PM para %s(%d): %s",iName,id,gMessage);
//ANTI-IP
new ver_string[128];
if(TimeStamp()-UltimaDivulgacaoStamp[playerid]>60){PlayerDivulgacoesIP[playerid] = 0;}
strmid(ver_string, gMessage, 0, strlen(gMessage));
if(FindIpPattern(playerid,ver_string)){
PlayerDivulgacoesIP[playerid]++;
if(PlayerDivulgacoesIP[playerid] > 1){
CallRemoteFunction("KickPlayerEx","is",playerid,"Tentou divulgar IP");
DIVULGACOES++;}else{
SendClientMessage(playerid, COLOR_YELLOW, "========================== [AVISO] ==========================");
SendClientMessage(playerid, COLOR_YELLOW, "O servidor detectou uma divulgação de IP em sua mensagem");
SendClientMessage(playerid, COLOR_YELLOW, "Se continuar a digitar esta mensagem, poderá ser kickado.");
SendClientMessage(playerid, COLOR_YELLOW, "===========================================================");
UltimaDivulgacaoStamp[playerid] = TimeStamp();
return 1;}return 1;}
//
new MessageToAdmins[128];
format(MessageToAdmins,sizeof(MessageToAdmins),"PM >> %s(%i) para %s(%i): %s",pName,playerid,iName,id,gMessage);
printf(MessageToAdmins);
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) < 4){
if(BPM[playerid] == 1) return SendClientMessage(playerid,Vred,"[ERRO]: Você deve desbloquear o seu recebimento de PM's para poder enviar.");
if(BPM[id] == 1) return SendClientMessage(playerid,Vred,"[ERRO]: O jogador bloqueou o recebimento de PMs ( Ele usou: /BPM )");
if(BloquearPMsDe[id] == playerid) return SendClientMessage(playerid,Vred,"[ERRO]: O jogador te bloqueou ( Ele usou: /BLOQUEAR <id> )");}
if(!IsPlayerConnected(playerid)) return 1;

//ADMINS VENDO PMs
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i)){
if(CallRemoteFunction("GetPlayerAdminLevel","i",i) >= 4){
if(id != i){
if(playerid != i){
SendClientMessage(i,COLOR_ORANGE,MessageToAdmins);}}}}}
PMTick[playerid] = TimeStamp();
SendClientMessage(playerid,PM_OUTGOING_COLOR,Message);
format(Message,sizeof(Message),"** PM de %s(%d): %s",pName,playerid,gMessage);SendClientMessage(id,PM_INCOMING_COLOR,Message);
SetPVarString(id,"UltimaPM",Message); // Salvar na memória
PlayerPlaySound(id,1057,0.0,0.0,0.0);
PlayerPlaySound(playerid,1057,0.0,0.0,0.0);PMS++;
strmid(LastText[playerid], gMessage, 0, strlen(gMessage), sizeof(LastText[]));
GameTextForPlayer(id,"~n~~n~~n~~n~~n~~n~~n~~y~PM RECEBIDA!", 3000, 5);
GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~g~PM ENVIADA!", 3000, 5);}else {
SendClientMessage(playerid,Vred,"[ERRO]: Voce não pode enviar PM para você mesmo");}return 1;}
//----------------------------------------------------------------------------------------------------------------------
return 0;}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock ClearSVStats()
{
new year,month,day,hour,minuite,second;
getdate(year, month, day);
gettime(hour,minuite,second);
format(DataStatus, sizeof(DataStatus), "Status desde: [Data: %d/%d/%d] [Hora: %d:%d]",day,month,year,hour,minuite);
VISITAS = 0;MORTES = 0;DIVULGACOES = 0;PMS = 0;MENSAGENS = 0;COMANDOS = 0;
FLOODKICKS = 0;MSINVALIDAS = 0;FLOODREPEATS = 0;TOTALREPEATS = 0;
CAIDOS = 0;SAIDAS = 0;KICKBAN = 0;VEICULOSUSADOS =0;
return 1;}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock PlayerIp(playerid)
{
new ip[16];
GetPlayerIp(playerid, ip, sizeof(ip));
return ip;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnFilterScriptInit( )
{
AntiDeAMX();
ClearSVStats();

for(new i; i < GetMaxPlayers(); i++)
if(IsPlayerConnected(i))
OnPlayerConnect(i);

return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnPlayerConnect(playerid)
{
PMTick[playerid] = 0;
Trollado[playerid] = false;
BloquearPMsDe[playerid] = -1;
VISITAS++;
strdel(LastText[playerid], 0, 256);
BPM[playerid] = 0;
REPEATS[playerid] = 0;
HAntiFlood[playerid] = TimeStamp();
HAntiFlood2[playerid] = TimeStamp();
UltimaDivulgacaoStamp[playerid] = 0;
PlayerDivulgacoesIP[playerid] = 0;
new PlayerName[MAX_PLAYER_NAME];
GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
if(IsIllegalName(PlayerName)){aKick(playerid,PlayerName);}
if(FindIpPattern(playerid,PlayerName)){aKick(playerid,PlayerName);}
if(IsForbiddenNameGlobal(PlayerName)){aKick(playerid,PlayerName);}


return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnPlayerDisconnect( playerid, reason )
{

//Desbloquear player
for(new i; i < GetMaxPlayers(); i++){
if(IsPlayerConnected(i)){
if(BloquearPMsDe[i] == playerid){
BloquearPMsDe[i] = -1;}}}

switch(reason){
case 0: CAIDOS++;
case 1: SAIDAS++;
case 2: KICKBAN++;}
if ( bIllegalPlayer[ playerid ] ){
bIllegalPlayer[ playerid ] = false;return 0;}
return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock aKick( playerid,pname[ ])
{
new szIP[ 16 ];
bIllegalPlayer[playerid] = true;
SetPlayerName( playerid, "_____");
GetPlayerIp( playerid, szIP, 16 );
SendClientMessage( playerid, 0xFFFFFFFF, "[SERVER]: Voce foi kickado por ter um nick ou parte dele proibido" );
Kick( playerid );
printf( "[ServerProtector] %s (%d:%s) foi kickado por ter um nickname ilegal.", pname, playerid, szIP );
new logstring[128];
format(logstring, sizeof(logstring), "%s (%d:%s) foi kickado por ter um nickname ilegal.",pname,playerid,szIP);
CallRemoteFunction("SaveToFile","ss","IllegalNickLogins",logstring);
return 0;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

IsIllegalName(name[]){
for(new i; i<sizeof(CrashNicks); i++){
if(strcmp(CrashNicks[i],name,true)==0){
return 1;}}return 0;}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward IsForbiddenNameGlobal(name[]);
public IsForbiddenNameGlobal(name[]){
for(new i; i<sizeof(NicksProibidosGlobal); i++){
if(strfind(name,NicksProibidosGlobal[i], true) != -1){
return 1;}}return 0;}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

forward FindIpPattern(playerid,const string[]);
public FindIpPattern(playerid,const string[])
{
	new stringNumeric=false;
	new stringBegin;
	new ipDigits=0;
	for(new i=0; i<strlen(string); i++)
	{
	    if(string[i]<='9' && string[i]>='0')
	    {
	        if(!stringNumeric) // first digit
	        {
	            stringNumeric=true;
	            stringBegin=i;
		 	    if(i==strlen(string)-1) // string ends with one digit number
		 	    {
			        ipDigits++;
			        if(ipDigits>3) // 4 digits
			            return 1;
		 	    }
	        }
	        else
		 	{
		 	    if(i==strlen(string)-1) // string ends with the last digit
		 	    {
	           		new stringn[256];
    	       		new number;
					for(new j=stringBegin; j<i+1; j++)
					    stringn[j-stringBegin]=string[j];
			        stringn[i-stringBegin+1]=0;
			        number=strval(stringn);
				    if(number>=0 && number<256) // our case
				    {
				        ipDigits++;
				        if(ipDigits>3) // 4 digits
				            return 1;
				    }
		 	    }
		 	}
	    }
	    else
	    {
	        if(stringNumeric) // last digit+1
	        {
	            stringNumeric=false;
           		new stringn[256];
           		new number;
				for(new j=stringBegin; j<i; j++)
				    stringn[j-stringBegin]=string[j];
		        stringn[i-stringBegin]=0;
		        number=strval(stringn);
			    if(number>=0 && number<256) // our case
			    {
			        ipDigits++;
			        if(ipDigits>3) // 4 digits
			            return 1;
			    }
			    else // not in ip-group range
			        ipDigits=0; // reset ip digit counter;
	        }
	    }
	}
	return 0;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock TimeStamp()
{
	new time = GetTickCount() / 1000;
	return time;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock IsNumeric(const string[])
{
  new length=strlen(string);
  if (length==0) return false;
  for (new i = 0; i < length; i++)
    {
      if (
            (string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') // Not a number,'+' or '-'
             || (string[i]=='-' && i!=0)                                             // A '-' but not at first.
             || (string[i]=='+' && i!=0)                                             // A '+' but not at first.
         ) return false;
    }
  if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
  return true;
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

stock ReturnPlayerID(PlayerName[]) {
for(new i; i < GetMaxPlayers(); i++)
if(IsPlayerConnected(i))
{
new name[24];
GetPlayerName(i,name,24);
if(strfind(name,PlayerName,true)!=-1)
return i;
}
return INVALID_PLAYER_ID;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com
