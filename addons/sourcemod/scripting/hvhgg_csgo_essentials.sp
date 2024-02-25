#include <sourcemod>
#include <cstrike>
#include <sdktools_gamerules>

ConVar hvh_restrict_untrusted_angles;
ConVar hvh_restrict_body_lean;
ConVar hvh_restrict_extended_angles;
ConVar hvh_restrict_fake_duck;
ConVar hvh_restrict_ax;

ConVar hvh_rage_quit;
ConVar hvh_reset_score;

public Plugin:myinfo = 
{ 
	name = "HvH.gg CS:GO Essentials", 
	author = "imi-tat0r", 
	description = "Core functionality for HvH servers", 
	version = "1.0.0"
};

public void OnPluginStart()
{
	// setup cvars
	hvh_restrict_untrusted_angles = CreateConVar("hvh_restrict_untrusted_angles", "1", "If this cvar is enabled, untrusted angles will be normalized/clamped", FCVAR_NOTIFY | FCVAR_REPLICATED);
	hvh_restrict_body_lean = CreateConVar("hvh_restrict_body_lean", "1", "If this cvar is enabled, body lean will be disabled", FCVAR_NOTIFY | FCVAR_REPLICATED);
	hvh_restrict_extended_angles = CreateConVar("hvh_restrict_extended_angles", "1", "If this cvar is enabled, extended angles will be disabled", FCVAR_NOTIFY | FCVAR_REPLICATED);
	hvh_restrict_fake_duck = CreateConVar("hvh_restrict_fake_duck", "0", "If this cvar is enabled, fake duck will be disabled", FCVAR_NOTIFY | FCVAR_REPLICATED);
	hvh_restrict_ax = CreateConVar("hvh_restrict_ax", "1", "If this cvar is enabled, AX will be disabled", FCVAR_NOTIFY | FCVAR_REPLICATED);

	hvh_rage_quit = CreateConVar("hvh_rage_quit", "1", "If this cvar is enabled, rage quit is enabled", FCVAR_NOTIFY | FCVAR_REPLICATED);
	hvh_reset_score = CreateConVar("hvh_reset_score", "1", "If this cvar is enabled, reset score is enabled", FCVAR_NOTIFY | FCVAR_REPLICATED);

	ServerCommand("mp_backup_round_file \"\"");
	ServerCommand("mp_backup_round_file_last \"\"");
	ServerCommand("mp_backup_round_file_pattern \"\"");
	ServerCommand("mp_backup_round_auto 0");

	RegConsoleCmd("rq", Command_RageQuit);
	RegConsoleCmd("ragequit", Command_RageQuit);
	
	RegConsoleCmd("rs", Command_ResetScore);
	RegConsoleCmd("resetscore", Command_ResetScore);
}

public void OnMapStart()
{
	ServerCommand("mp_backup_round_file \"\"");
	ServerCommand("mp_backup_round_file_last \"\"");
	ServerCommand("mp_backup_round_file_pattern \"\"");
	ServerCommand("mp_backup_round_auto 0");
}

public Action Command_RageQuit(int client, int args) 
{
	// feature disabled
	if (!GetConVarBool(hvh_rage_quit))
		return Plugin_Handled;
	
	// invalid client
	if (!IsValidClient(client)) 
		return Plugin_Handled;
	
	// get client name
	char name[MAX_NAME_LENGTH];
	GetClientName(client, name, sizeof(name));
	
	// public shame
	PrintToChatAll("[\x07Hv\x02H\x01.gg] \x07%s\x01 just rage quit.", name)
	
	// kick message
	KickClient(client, "Rage quit!");
	return Plugin_Handled;
}

public Action Command_ResetScore(int client, int args)
{
	// feature disabled
	if (!GetConVarBool(hvh_reset_score))
		return Plugin_Handled;
	
	// invalid client
	if (!IsValidClient(client))
		return Plugin_Handled;

	// get client name
	char name[MAX_NAME_LENGTH];
	GetClientName(client, name, sizeof(name));
	
	// check if already 0
	if(GetClientDeaths(client) == 0 && GetClientFrags(client) == 0 && CS_GetClientAssists(client) == 0 && CS_GetMVPCount(client) == 0)
	{
		PrintToChat(client, "[\x07Hv\x02H\x01.gg] Your score already is 0.")
		return Plugin_Continue;
	}
	
	// reset stats
	SetEntProp(client, Prop_Data, "m_iFrags", 0);
	SetEntProp(client, Prop_Data, "m_iDeaths", 0);
	CS_SetMVPCount(client, 0);
	CS_SetClientAssists(client, 0);
	CS_SetClientContributionScore(client, 0);
	
	// public shame
	PrintToChatAll("[\x07Hv\x02H\x01.gg] Player \x07%s\x01 just reset their score.", name)
	return Plugin_Handled;
}


public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{
	// player is dead, continue
	new bool:alive = IsPlayerAlive(client);
	if(!alive)
		return Plugin_Continue;

	// ax fix
	if (GetConVarBool(hvh_restrict_ax))
	{
		if (!GetEntProp(client, Prop_Data, "m_bLagCompensation"))
			SetEntProp(client, Prop_Data, "m_bLagCompensation", 1);
	}

	// fake duck fix
	if (GetConVarBool(hvh_restrict_fake_duck))
	{
		if( buttons & IN_BULLRUSH )
			buttons &= ~IN_BULLRUSH;
	}

	// untrusted angles fix
	if (GetConVarBool(hvh_restrict_untrusted_angles))
	{
		// pitch clamp
		if (angles[0] > 89.0)
			angles[0] = 89.0;
		else if (angles[0] < -89.0)
			angles[0] = -89.0;

		// yaw clamp
		if (angles[1] > 180.0)
			angles[1] = 180.0;
		if(angles[1] < -180.0)
			angles[1] = -180.0;
		
		// roll clamp
		if (angles[2] > 90.0)
			angles[2] = 90.0;
		else if (angles[2] < -90.0)
			angles[2] = -90.0;
	}
	
	// roll disable
	if (GetConVarBool(hvh_restrict_body_lean))
	{
		if(angles[2] != 0.0)
			angles[2] = 0.0;
	}

	return Plugin_Changed;
}

// primordial fix - credits: https://github.com/r4klatif/extended-angle-fix
public void OnPlayerRunCmdPost(int client, int buttons, int impulse, const float vel[3], const float angles[3], int weapon, int subtype, int cmdnum, int tickcount, int seed, const int mouse[2])
{
	if (!GetConVarBool(hvh_restrict_extended_angles))
		return;
	
	float eye_angles[3];
	float v_angle[3];

	GetEntPropVector(client, Prop_Data, "v_angle", v_angle);

	eye_angles[0] = GetEntPropFloat(client, Prop_Send, "m_angEyeAngles[0]");
	eye_angles[1] = GetEntPropFloat(client, Prop_Send, "m_angEyeAngles[1]");
	eye_angles[2] = v_angle[2];

	SetEntPropVector(client, Prop_Data, "v_angle", eye_angles);
}

stock bool IsValidClient(int client)
{
	if(client <= 0 ) return false;
	if(client > MaxClients) return false;
	if(!IsClientConnected(client)) return false;
	return IsClientInGame(client);
}