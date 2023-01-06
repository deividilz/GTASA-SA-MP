// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

#include <a_samp>

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

#define Branco             											            0xFFFFFFAA
#define Cinza                                                                   0xC0C0C0AA
#define Amarelo                                                                 0xFFFF00FF
#define Dourado                                                                 0xDDB66BFF
#define Vermelho                                                                0xFF0000AA
#define VermelhoEscuro                                                          0xfAA3333AA
#define VerdeClaro                                                              0x8BF63EFF
#define AzulClaro 																0x33CCFFAA
#define AzulEscuro                                                              0x057ABDAA
#define Roxo                                                                    0xB96BF6FF
#define Laranja                                                         	 	0xFF8000FF

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

#define VotacaoDialog 487

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

new bool:Enquete,bool:EnqueteVotou[MAX_PLAYERS],
TotalEnqueteVotos,EnqueteVotosSim,EnqueteVotosNao,
EnqueteMensagem[256],EnqueteMensagemDialog[256];

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnFilterScriptInit()
{
for(new i; i < GetMaxPlayers(); i++) EnqueteVotou[i] = false;
Enquete = false;
EnqueteVotosSim = 0;
EnqueteVotosNao = 0;
return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnFilterScriptExit()
{
for(new i; i < GetMaxPlayers(); i++) EnqueteVotou[i] = false;
Enquete = false;
EnqueteVotosSim = 0;
EnqueteVotosNao = 0;
return 1;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid == VotacaoDialog) {
if(response) {
EnqueteVotou[playerid] = true;
EnqueteVotosSim++;
new SoundX,SoundY,SoundZ; PlayerPlaySound(playerid, 1057, SoundX, SoundY, SoundZ);
SendClientMessage(playerid, Amarelo, "[INFO]: Seu voto \"sim\" foi registrado, obrigado por participar.");
} else {
EnqueteVotou[playerid] = true;
EnqueteVotosNao++;
new SoundX,SoundY,SoundZ; PlayerPlaySound(playerid, 1057, SoundX, SoundY, SoundZ);
SendClientMessage(playerid, Amarelo, "[INFO]: Seu voto \"não\" foi registrado, obrigado por participar.");
}
return 1;
}
return 0;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

dcmd_enquete(playerid,params[]) {
if(CallRemoteFunction("GetPlayerAdminLevel","i",playerid) > 0){
new StringEnquete[128],StringEnquete2[128];
new EnqueteMsg[128],EnqueteMsgIndex; EnqueteMsg = strtok(params,EnqueteMsgIndex);
if(!strlen(params)) return SendClientMessage(playerid, Cinza, "Uso: /Enquete [Enquete/Frase] | Encerrar");
if(!strcmp(params,"encerrar",true)) {
if(Enquete == true) {
TotalEnqueteVotos = EnqueteVotosSim+EnqueteVotosNao;
new AdministradorNick[MAX_PLAYER_NAME]; GetPlayerName(playerid, AdministradorNick, sizeof(AdministradorNick));
SendClientMessageToAll(Branco, "=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=");
format(StringEnquete, sizeof(StringEnquete), "> Administrador(a) %s encerrou a Enquete.", AdministradorNick);
SendClientMessageToAll(Roxo, StringEnquete);
SendClientMessageToAll(Branco, " ");
SendClientMessageToAll(VerdeClaro, EnqueteMensagem);
SendClientMessageToAll(Branco, " ");
format(StringEnquete2, sizeof(StringEnquete2), "Votos: %d     |     Sim: %d (%d)      |     Não: %d (%d)", TotalEnqueteVotos, EnqueteVotosSim, EnqueteVotosSim*100/TotalEnqueteVotos, EnqueteVotosNao, EnqueteVotosNao*100/TotalEnqueteVotos);
SendClientMessageToAll(Amarelo, StringEnquete2);
SendClientMessageToAll(Branco, "=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=");
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i))
{
new SoundX,SoundY,SoundZ; PlayerPlaySound(i, 1057, SoundX, SoundY, SoundZ);
EnqueteVotou[i] = false;
}}
EnqueteVotosSim = 0;
EnqueteVotosNao = 0;
Enquete = false;
return 1;
} else return SendClientMessage(playerid, Vermelho, "[ERRO]: Não há nenhuma enquete aberta.");
}
else
if(Enquete == false) {
new AdministradorNick[MAX_PLAYER_NAME]; GetPlayerName(playerid, AdministradorNick, sizeof(AdministradorNick));
SendClientMessageToAll(Branco, "=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=");
format(StringEnquete, sizeof(StringEnquete), "> Administrador(a) %s iniciou uma Enquete.", AdministradorNick);
SendClientMessageToAll(Roxo, StringEnquete);
SendClientMessageToAll(Branco, " ");
format(StringEnquete2, sizeof(StringEnquete2), "Enquete: %s", params);
SendClientMessageToAll(VerdeClaro, StringEnquete2);
SendClientMessageToAll(Branco, " ");
SendClientMessageToAll(Amarelo, "Use para votar:      /Sim      &      /Nao.");
SendClientMessageToAll(Branco, "=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=");
for(new i; i < GetMaxPlayers(); i++){if(IsPlayerConnected(i))
{
new SoundX,SoundY,SoundZ; PlayerPlaySound(i, 1056, SoundX, SoundY, SoundZ);
EnqueteVotou[i] = false;
}}
EnqueteVotosSim = 0;
EnqueteVotosNao = 0;
Enquete = true;
format(EnqueteMensagem, sizeof(EnqueteMensagem), "Enquete: %s", params);
format(EnqueteMensagemDialog, sizeof(EnqueteMensagemDialog), "Enquete: %s\n\nSelecione uma opção de voto.", params);
return 1;
} else return SendClientMessage(playerid, Vermelho, "[ERRO]: Há uma enquete em andamento.");
} else return 0;
}

dcmd_sim(playerid,params[]) {
#pragma unused params
if(Enquete == true) {
if(EnqueteVotou[playerid] == false) {
EnqueteVotou[playerid] = true;
EnqueteVotosSim++;
new SoundX,SoundY,SoundZ; PlayerPlaySound(playerid, 1057, SoundX, SoundY, SoundZ);
SendClientMessage(playerid, Amarelo, "> Seu voto \"sim\" foi registrado, obrigado por participar.");
} else return SendClientMessage(playerid, Vermelho, "[ERRO]: Você já votou, aguarde o resultado da enquete.");
} else return SendClientMessage(playerid, Vermelho, "[ERRO]: Não há nenhuma enquete aberta.");
return 1;
}

dcmd_nao(playerid,params[]) {
#pragma unused params
if(Enquete == true) {
if(EnqueteVotou[playerid] == false) {
EnqueteVotou[playerid] = true;
EnqueteVotosNao++;
new SoundX,SoundY,SoundZ; PlayerPlaySound(playerid, 1057, SoundX, SoundY, SoundZ);
SendClientMessage(playerid, Amarelo, "> Seu voto \"não\" foi registrado, obrigado por participar.");
} else return SendClientMessage(playerid, Vermelho, "Erro: Você já votou, aguarde o resultado da enquete.");
} else return SendClientMessage(playerid, Vermelho, "Erro: Não há nenhuma enquete aberta.");
return 1;
}

/*dcmd_votar(playerid,params[]) {
#pragma unused params
if(Enquete == true) {
if(EnqueteVotou[playerid] == false) {
ShowPlayerDialog(playerid, VotacaoDialog, DIALOG_STYLE_MSGBOX, "Enquete - Votação", EnqueteMensagemDialog, "Sim", "Não");
} else return SendClientMessage(playerid, Vermelho, "Erro: Você já votou, aguarde o resultado da enquete.");
} else return SendClientMessage(playerid, Vermelho, "Erro: Não há nenhuma enquete aberta.");
return 1;
}*/

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

public OnPlayerCommandText(playerid, cmdtext[])
{
dcmd(enquete,7,cmdtext);
dcmd(sim,3,cmdtext);
dcmd(nao,3,cmdtext);
//dcmd(votar,5,cmdtext);
return 0;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com

stock strtok(const string[], &index,seperator=' ')
{
new length = strlen(string);
new offset = index;
new result[128];
while ((index < length) && (string[index] != seperator) && ((index - offset) < (sizeof(result) - 1)))
{
result[index - offset] = string[index];
index++;
}

result[index - offset] = EOS;
if ((index < length) && (string[index] == seperator))
{
index++;
}
return result;
}

// Striker Samp - Tudo Para Seu Servidor SA-MP
// www.strikersamp.blogspot.com
