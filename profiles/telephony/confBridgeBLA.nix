{ config, pkgs, ... }:

{
  services.asterisk = {
    otherConfig =
    {
      "modules.conf" = ''
        [modules]
        autoload = yes

        load => bridge_builtin_features.so
        load => res_timing_timerfd.so
        load => app_confbridge.so
        load => chan_sip.so
      '';
      "bla.conf" = ''
        [line1]
        type=trunk
;        device=DAHDI/1
        autocontext=line1
         
        [line2]
        type=trunk
;        device=DAHDI/2
        autocontext=line2
         
        [station]
        type=station
        trunk=line1
        trunk=line2
        autocontext=bla_stations
         
        [station1](station)
        device=SIP/station1
         
        [station2](station)
        device=SIP/station2
         
        [station3](station)
        device=SIP/station3
      '';
      "confbridge.conf" = ''
        [general]

        [default_user]
        type=user

        [default_bridge]
        type=bridge
      '';
      "extensions.conf" = ''
        [line1]
        ; The backend treats BLATrunk() like a conference room
        exten => s,1,BLATrunk(line1)
         
        [line2]
        exten => s,2,BLATrunk(line2)
         
        [bla_stations]
        exten => station1,1,BLAStation(station1)
        exten => station1_line1,hint,BLA:station1_line1
        exten => station1_line1,1,BLAStation(station1_line1)
        exten => station1_line2,hint,BLA:station1_line2
        exten => station1_line2,1,BLAStation(station1_line2)
        exten => station2,1,BLAStation(station2)
        exten => station2_line1,hint,BLA:station2_line1
        exten => station2_line1,1,BLAStation(station2_line1)
        exten => station2_line2,hint,BLA:station2_line2
        exten => station2_line2,1,BLAStation(station2_line2)
        exten => station3,1,BLAStation(station3)
        exten => station3_line1,hint,BLA:station3_line1
        exten => station3_line1,1,BLAStation(station3_line1)
        exten => station3_line2,hint,BLA:station3_line2
        exten => station3_line2,1,BLAStation(station3_line2)

        [softphones]
        include => bla_stations
      '';
    };
  };
}
