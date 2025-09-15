classdef ClassEncoder < handle
    properties (SetAccess = private) % Переменные из параметров
        % Нужно ли выполнять кодирование и декодирование
            isTransparent;
		% В данной работе рассматриваются два типа кодирования 
		% (сверточное и LDPC по стандарту DVB-S2). 
        % Здесь нужно определить какие переменные, 
		% которые используются для выполнения функций кодирования /
		% декодирования.
		% Например, для сверточного кодирования в матлабе есть функции для
		% кодирования и декодирования:
		% Для кодирования https://www.mathworks.com/help/comm/ref/convenc.html
		%	OutData =  convenc(InData, Trellis);
		% Для декодирования https://www.mathworks.com/help/comm/ref/vitdec.html
		% используется алгоритм Витерби
		%   OutData =  vitdec(InData, Trellis, TbDepth, 'trunc',...
		%		DecodingType);
		% InData - последовательность бит, которая получается после блока Source
		% (ClassSource).
		% Из примера видно, что для выполнения двух функций кодирования и
		% декодирования сверточного кода нужно инициализировать следующие 
		% параметры: 
		% Trellis - полином; пример: Trellis = poly2trellis(poly2trellis(7,[171 133]);)
		% TbDepth - traceback depth
		% DecodingType - Тип декодирования: с жесткими решениями или с мягкими решениями
		% Все значения переменных можно посмотреть в примерах в Matlab.
		
		
		% Для LDPC кода прочитайте в ссылках
		% https://www.mathworks.com/help/comm/ref/comm.ldpcencoder-system-object.html
		% https://www.mathworks.com/help/comm/ref/comm.ldpcdecoder-system-object.html
		
		% Потому, что мы рассматриваем два типа кодирования поэтому ещё нужна одна 
		% переменная для определения типа кодирования (либо CC, либо LDPC).
		
		% ЗАДАНИЯ:
		% 1) Нарисовать кривые помехоустойчивости приема сигналов BPSK, QPSK, ...
		% QAM16 с использованием сверточного кодирования.
        % 1.1) Сравнить помехоустойчивость приёма сигналов для созвездий ФМ-4 и КАМ-16 
        % без использования свёрточного кодирования и при использовании свёрточного кодирования 
        % для трёх типов вариантов решений (с жёсткими решениями, с мягкими решениями и 
        % с мягкими решениями с аппроксимацией), выносимых демодулятором. 
        % Сохранить результаты битовой помехоустойчивости для вероятности
        % 10–4. 
        % 1.2) Исследовать зависимость битовой и кадровой помехоустойчивости 
        % при использовании свёрточного кодирования от длины информационного 
        % блока N = 6, N = 10, N = 100.


        % 2) Для LDPC кодирования.
        % 2.1) Сравнить полученные 
		% кривые помехоустойчивости с теоретическими кривыми помехоустойчивости 
		% приема сигналов BPSK, QPSK, QAM16 в канале АБГШ. Для LDPC выбрать любое 
		% значение скорости кодирования. 
        % 2.2) Исследование BER и FER в случае применения и без применения
        % перемежения. 
		
		% 3) Из полученных кривых помехоустойчивости нужно выразить точки спектральной 
		% эффективности на плоскости Шеннона. (на уровне BER = 10^-3)
		
		
		% Пример кода для сверточного кода
		
        % Тип кодирования (Convolution/LDPC)
            TypeEncoder;
        % Полимом
            Trellis;
        % tb depth
            TbDepth;
        % Тип декодирования
            DecodingType;
        % Переменная управления языком вывода информации для пользователя
            LogLanguage;
    end
    properties (SetAccess = private) % Вычисляемые переменные
        % Общая скорость кодирования (для CC вычисляется из trellis,
        % для LDPC задаётся параметром)
        CodeRate;
        % Строковое значение скорости для LDPC (используется dvbs2ldpc)
        CodeRateStr;
    end
    methods
        function obj = ClassEncoder(Params, LogLanguage) % Конструктор
			% Все значения переменных нужно задать в скрипте SetParams.m
			% (в функции Encoder = SetParamsEncoder(inEncoder, ParamsNumber, ...
			% 	LogLanguage) %#ok<INUSD,DEFNU>)
			% или в скрипте Setup.m
			
            % Выделим поля Params, необходимые для инициализации
                Encoder  = Params.Encoder;
            % Инициализация значений переменных из параметров
                obj.isTransparent = Encoder.isTransparent;
            % Тип кодирования
                obj.TypeEncoder = Encoder.TypeEncoder;
            % Полином
                obj.Trellis = Encoder.Trellis;
            % tb depth
                obj.TbDepth = Encoder.TbDepth;
            % Тип декодирования
                obj.DecodingType = Encoder.DecodingType;
        if obj.isTransparent
            obj.CodeRate = 1;
            obj.CodeRateStr = '1';
        else
            switch obj.TypeEncoder
                case 'Convolution'
                    obj.CodeRate = log2(obj.Trellis.numInputSymbols) / ...
                                   log2(obj.Trellis.numOutputSymbols);
                    obj.CodeRateStr = '';
                case 'LDPC'
                    obj.CodeRateStr = Encoder.CodeRate;
                    obj.CodeRate = eval(Encoder.CodeRate);
            end
        end
            % Переменная LogLanguage
                obj.LogLanguage = LogLanguage;
        end
        function OutData = StepTx(obj, InData)
			
			% Source -> Coding -> Interleaving -> Modulation -> Channel
			% InData - выход блока Source = вход блока Coding
			% Output - выход блока Coding
			% Кодирование 
			% Если obj.isTransparent = true - тогда нет блока кодирования, т.есть
			% OutData = InData
			
            if obj.isTransparent
				% то есть без кодирования 
                OutData = InData;
                return
            end
            
			% Если obj.isTransparent = false - есть кодирование
            % Здесь должна быть процедура кодирования
            switch obj.TypeEncoder
                case 'Convolution'
					% Процесс кодирования 
                    OutData = convenc(InData, obj.Trellis);
                case 'LDPC'
                    H = dvbs2ldpc(obj.CodeRateStr);
                    ldpcEnc = comm.LDPCEncoder(H);
                    OutData = ldpcEnc(InData);
            end
            
        end
        function OutData = StepRx(obj, InData)
			% Декодирование
			% Demodulation -> De-Interleaving -> Decoding -> BER Calculation
            if obj.isTransparent
                OutData = InData;
                return
            end
            
            % Здесь должна быть процедура декодирования
            switch obj.TypeEncoder
                case 'Convolution'
                    OutData = vitdec(InData, obj.Trellis, obj.TbDepth, 'trunc', obj.DecodingType);
                case 'LDPC'
                    H = dvbs2ldpc(obj.CodeRateStr);
                    ldpcDec = comm.LDPCDecoder(H);
                    OutData = ldpcDec(InData);
            end
                 
        end
    end
end