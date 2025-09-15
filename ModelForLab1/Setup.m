
% Р‘РµР· РёСЃРїРѕР»СЊР·РѕРІР°РЅРёСЏ СЃРІРµСЂС‚РѕС‡РЅРѕРіРѕ РєРѕРґР°
	Common.SaveFileName = 'QAM16_NoEncoder'; % РРјСЏ С„Р°Р№Р»Р° СЂРµР·СѓР»СЊС‚Р°С‚Р°
% РќР°СЃС‚СЂРѕР№РєР° РїР°СЂР°РјРµС‚СЂРѕРІ РІ classEncoder
	Encoder.isTransparent = true; % Р±РµР· РєРѕРґРёСЂРѕРІР°РЅРёСЏ
% РќР°СЃС‚СЂРѕР№РєР° РїР°СЂР°РјРµС‚СЂРѕРІ РІ classMapper
	Mapper.isTransparent = false; 
	Mapper.ModulationOrder = 16;
	Mapper.DecisionMethod = 'Hard decision'; 
% РќР°СЃС‚СЂРѕР№РєР° РїР°СЂР°РјРµС‚СЂРѕРІ РІ classChannel
	Channel.isTransparent = false;   
% End of Params

% Р’РђР–РќРћ: Р”Р»СЏ РєР°Р¶РґРѕРіРѕ РЅР°Р±РѕСЂР° РїР°СЂР°РјРµС‚СЂРѕРІ РЅСѓР¶РЅРѕ РїРѕСЃС‚Р°РІРёС‚СЊ % End of Params РІ РєРѕРЅС†Рµ


% РЎ РёСЃРїРѕР»СЊР·РѕРІР°РЅРёРµРј СЃРІРµСЂС‚РѕС‡РЅРѕРіРѕ РєРѕРґР°

	% QAM16 + CC + СЃ Р¶РµСЃС‚РєРёРјРё СЂРµС€РµРЅРёСЏРјРё
		Common.SaveFileName = 'QAM16_Encoder_HardDecision';
		Encoder.isTransparent = false; 
		Encoder.Trellis = poly2trellis(7,[171 133]); 
		Encoder.TbDepth = 96; 
		Encoder.DecodingType ='hard'; 
		Mapper.isTransparent = false; 
		Mapper.ModulationOrder = 16; 
		Mapper.DecisionMethod = 'Hard decision'; 
		Channel.isTransparent = false;  
		% End of Params
	
	% QAM16 + CC + СЃ РјСЏРіРєРёРјРё СЂРµС€РµРЅРёСЏРјРё
		Common.SaveFileName = 'QAM16_Encoder_SoftDecision_LLR'; 
		Encoder.isTransparent = false; 
		Encoder.Trellis = poly2trellis(7,[171 133]); 
		Encoder.TbDepth = 96; 
		Encoder.DecodingType ='unquant'; 
		Mapper.isTransparent = false; 
		Mapper.ModulationOrder = 16; 
		Mapper.DecisionMethod = 'Log-likelihood ratio'; 
		Channel.isTransparent = false; 
		% End of Params
	
	% QAM16 + CC + СЃ РјСЏРіРєРёРјРё СЂРµС€РµРЅРёСЏРјРё СЃ Р°РїРїСЂРѕСЃРёРјР°С†РёРµР№
		
		Common.SaveFileName = 'QAM16_Encoder_SoftDecision_ALLR'; 
		Encoder.isTransparent = false; 
		Encoder.Trellis = poly2trellis(7,[171 133]); 
		Encoder.TbDepth = 96; 
		Encoder.DecodingType ='unquant'; 
		Mapper.isTransparent = false; 
		Mapper.ModulationOrder = 16; 
                Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
                Channel.isTransparent = false;
                % End of Params

% PSK16 + LDPC (rate 3/5) + soft decisions
    Common.SaveFileName = 'PSK16_LDPC_R3_5';
    Encoder.isTransparent = false;
    Encoder.TypeEncoder   = 'LDPC';
    Encoder.CodeRate      = '3/5';
    Mapper.isTransparent  = false;
    Mapper.Type           = 'PSK';
    Mapper.ModulationOrder= 16;
    Mapper.DecisionMethod = 'Log-likelihood ratio';
    Channel.isTransparent = false;
    % End of Params
