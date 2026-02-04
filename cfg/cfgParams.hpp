class RB_Header_1
{
    title = "• Persistence •";
    values[] = {0};
    texts[] = {""};
    default = 0;
};
class RB_LoadSaveSlot
{
    title = "Persistence: Load Save Slot";
    values[] = {0, 1, 2, 3};
    texts[] = {"Fresh Start", "Load Slot 1", "Load Slot 2", "Load Slot 3"};
    default = 0;
};
class RB_Spacer_1
{
    title = " ";
    values[] = {0};
    texts[] = {""};
    default = 0;
};
class RB_Header_2
{
    title = "• Player Classes •";
    values[] = {0};
    texts[] = {""};
    default = 0;
};
class RB_LogisticsFaction
{
    title = "Player Faction";
    values[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    texts[] = {"Custom", "Vanilla NATO", "APEX NATO", "Contact NATO", "Contact LDF", "APEX Gendarmerie", "CDLC Western Sahara UNA", "RHS US Army", "3CB British Armed Forces", "CDLC S.O.G. Prairie Fire US Army", "CDLC Expeditionary Forces MJTF"};
    default = 1;
};
class RB_AmbientAir {
    title = "Ambient Air Activity";
    values[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    texts[] = {"Disabled", "Custom", "NATO", "APEX NATO", "APEX Gendarmerie", "CDLC WS UNA", "RHS US Army", "3CB British Armed Forces", "CDLC S.O.G. Prairie Fire", "CDLC Expeditionary Force MJTF"};
    default = 2;
};
class RB_AmbientAirIntensity {
    title = "Ambient Air Frequency";
    values[] = {0, 1, 2, 3};
    texts[] = {"Low", "Medium", "High", "Very High"};
    default = 1;
};
class RB_Spacer_2
{
    title = " ";
    values[] = {0};
    texts[] = {""};
    default = 0;
};
class RB_Header_3
{
    title = "• Civilian Classes •";
    values[] = {0};
    texts[] = {""};
    default = 0;
};
class RB_CivilianPool {
    title = "Civilian Class Pool";
    values[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
    texts[] = {"Custom","Vanilla", "Vanilla African", "Vanilla Asian", "Vanilla Eastern European", "Vanilla Tanoan", "Vanilla Mixed", "CDLC Sefrou-Ramal", "3CB African", "3CB Chernarus", "3CB Middle Eastern", "SOGPF Vietnamese"};
    default = 6;
};
class RB_CivilianVehiclePool {
    title = "Civilian Vehicle Pool";
    values[] = {0, 1, 2, 3, 4, 5, 6};
    texts[] = {"Custom", "Vanilla Vehicles", "3CB Vehicles", "CUP Western Vehicles", "CUP Middle Eastern Vehicles", "RDS Vehicles", "SOGPF Vehicles"};
    default = 1;
};
class RB_AmbientTrafficIntensity {
        title = "Ambient Civilian Traffic Intensity";
        values[] = {0,1,2,3,4};
        texts[] = {"Disabled", "Low", "Medium", "High", "Very High"};
        default = 2; // Medium
    };
class RB_Spacer_3
{
    title = " ";
    values[] = {0};
    texts[] = {""};
    default = 0;
};
class RB_Header_4
{
    title = "• Enemy Classes •";
    values[] = {0};
    texts[] = {""};
    default = 0;
};
class RB_EnemyFaction {
    title = "Enemy Infantry Pool";
    values[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21};
    texts[] = {"Custom", "Vanilla FIA Insurgents", "Vanilla(Contact) Livonia Looters", "Vanilla(Apex) Syndikat Bandits", "Vanilla(Apex) Syndikat Paramilitary", "Vanilla CSAT", "Vanilla(Contact) Spetznas", "CDLC Western Sahara Tura", "CDLC Western Sahara SFIA", "RHS GREF CHDKZ", "RHS GREF NAPA", "SOGPF Vietcong", "3CB Takistan Insurgents", "3CB Middle Eastern Insurgents", "3CB Middle Eastern Extremists", "3CB Malden Defense Force", "3CB Livonia Separatist Militia", "3CB Livonia National Militia", "3CB FIA", "3CB African Desert Militia", "3CB African Desert Extremists", "3CB African Deserts Civilian Militia"};
    default = 1;
};

class RB_EnemyVehiclePool {
    title = "Enemy Vehicle Pool";
    values[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17};
    texts[] = {"Custom", "Vanilla", "CDLC Western Sahara", "CUP Takistani Militia", "CUP Chernarussian Movement of the Red Star", "SOGPF Vehicles", "RHS GREF CHDKZ", "RHS GREF NAPA", "3CB Takistan Insurgents", "3CB Middle Eastern Insurgents", "3CB Middle Eastern Extremists", "3CB Malden Defense Force", "3CB Livonia Separatists Militia", "3CB Livonia National Militia", "3CB FIA", "3CB African Desert Militia", "3CB African Desert Extremists", "3CB African Desert Civilian Militia"};
    default = 1;
};
class RB_Spacer_4
{
    title = " ";
    values[] = {0};
    texts[] = {""};
    default = 0;
};
class RB_Header_5
{
    title = "• Difficulty Settings •";
    values[] = {0};
    texts[] = {""};
    default = 0;
};
class RB_RespawnCost {
    title = "Respawn Point Cost";
    values[] = {0,10,15,20,25,50,75,100};
    texts[]  = {"Free", "10", "15", "20", "25", "50", "75", "100"};
    default = 25;
};
class RB_EnableMortars {
    title = "Enable Ambient Mortar Strikes";
    values[] = {0, 1};
    texts[] = {"Disabled", "Enabled"};
    default = 1;
};
    class RB_EnemyAttackChance {
    title = "Enemy Attack Chance After Mortar Strike";
    values[] = {0, 25, 50, 75, 100};
    texts[] = {"0% (Disabled)", "25%", "50%", "75%", "100%"};
    default = 50;
};
class RB_Intensity {
    title = "Roadblock Traffic Frequency";
    values[] = {0, 1, 2, 3};
    texts[] = {"Low", "Medium", "High", "Very High"};
    default = 1;
};
class RB_EnemyAttackIntensity {
    title = "Enemy Attack Frequency";
    values[] = {0, 1, 2, 3};
    texts[] = {"Low", "Medium", "High", "Very High"};
    default = 1;
};
class RB_EnemyVehicleFrequency {
    title = "Enemy Vehicle Frequency";
    values[] = {0, 1, 2, 3};
    texts[] = {"Low", "Medium", "High", "Very High"};
    default = 1;
};