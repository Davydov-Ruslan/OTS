
% Без использования сверточного кода
	Common.SaveFileName = 'QAM16_NoEncoder'; % Имя файла результата
% Настройка параметров в classEncoder
	Encoder.isTransparent = true; % без кодирования
% Настройка параметров в classMapper
	Mapper.isTransparent = false; 
	Mapper.ModulationOrder = 16;
	Mapper.DecisionMethod = 'Hard decision'; 
% Настройка параметров в classChannel
	Channel.isTransparent = false;   
% End of Params

% ВАЖНО: Для каждого набора параметров нужно поставить % End of Params в конце


% С использованием сверточного кода

	% QAM16 + CC + с жесткими решениями
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
	
	% QAM16 + CC + с мягкими решениями
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
	
	% QAM16 + CC + с мягкими решениями с аппросимацией
		
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
