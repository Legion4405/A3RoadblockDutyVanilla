// File: scripts\initBriefing.sqf
// Adds all Roadblock Duty diary briefing categories and entries for the local player

// SITUATION
if !(player diarySubjectExists "Roadblock Briefing") then {
    player createDiarySubject ["Roadblock Briefing", "Roadblock Briefing"];
};
player createDiaryRecord [
    "Roadblock Briefing",
    [
        "Current Situation",
        "Local insurgent groups have intensified smuggling operations, blending contraband and explosives into civilian cargo shipments.
Reports indicate they frequently utilize stolen vehicles and forged documentation to bypass security checkpoints."
    ]
];

player createDiaryRecord [
    "Roadblock Briefing",
    [
        "Mission",
        "Stop and thoroughly search every civilian and vehicle passing through the checkpoint.
        Verify vehicle registrations and documentation to identify stolen or fraudulent vehicles.
        Scan vehicles and personnel carefully for concealed explosives or hidden contraband.
        Immediately detain suspicious individuals or impound vehicles exhibiting suspicious or illegal activities.
        Maintain strict adherence to protocol to avoid wrongful arrests, ensuring local civilian support remains intact."
    ]
];

player createDiaryRecord [
    "Roadblock Briefing",
    [
        "Friendly Forces",
        "You are operating as part of a dedicated 10-man checkpoint security squad, tasked specifically with managing and securing the roadblock.
A logistics squadron is stationed nearby, providing periodic resupply, vehicle maintenance, and emergency support when requested.
Broader counter-insurgency (COIN) operations are actively ongoing in surrounding sectors, so friendly air assets may periodically pass through."
    ]
];

player createDiaryRecord [
    "Roadblock Briefing",
    [
        "Enemy Forces",
        "Enemy insurgent forces vary widely in size and may approach the checkpoint from multiple directions, testing defenses unpredictably.
They frequently employ vehicles for rapid deployment of operatives or direct assault attempts on the roadblock position.
Be alert for enemy indirect fire capabilities; insurgents are known to occasionally launch mortar strikes to suppress and destabilize checkpoint operations."
    ]
];

player createDiaryRecord [
    "Roadblock Briefing",
    [
        "Commander's Intent",
        "Establish dominance over key transit routes by systematically intercepting smuggling operations, contraband, and explosive threats.
Maintain constant vigilance and adaptability to effectively counter insurgent attacks from varying directions and methods.
Exercise thoroughness and discretion to minimize civilian disruptions and wrongful detentions, preserving local support and cooperation.
Ensure your checkpoint remains operational despite potential indirect fire or direct assaults; stability in the region depends on your team's effectiveness and precision."
    ]
];

player createDiaryRecord [
    "Roadblock Briefing",
    [
        "Logistics",
        "A dedicated logistics squadron stationed nearby provides essential mission support, allowing your team to requisition additional supplies, specialized gear, weaponry, and fortification upgrades.
Utilize the checkpoint terminal interface to request logistics deliveries based on mission performance and available operational points.
Carefully prioritize your requisitions; ammunition, medical supplies, defensive assets, and enhanced equipment are available, but resources are limited and must be managed strategically."
    ]
];
