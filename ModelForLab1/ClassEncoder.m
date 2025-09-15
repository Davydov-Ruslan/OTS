classdef ClassEncoder < handle
    properties (SetAccess = private) % ���������� �� ����������
        % ����� �� ��������� ����������� � �������������
            isTransparent;
		% � ������ ������ ��������������� ��� ���� ����������� 
		% (���������� � LDPC �� ��������� DVB-S2). 
        % ����� ����� ���������� ����� ����������, 
		% ������� ������������ ��� ���������� ������� ����������� /
		% �������������.
		% ��������, ��� ����������� ����������� � ������� ���� ������� ���
		% ����������� � �������������:
		% ��� ����������� https://www.mathworks.com/help/comm/ref/convenc.html
		%	OutData =  convenc(InData, Trellis);
		% ��� ������������� https://www.mathworks.com/help/comm/ref/vitdec.html
		% ������������ �������� �������
		%   OutData =  vitdec(InData, Trellis, TbDepth, 'trunc',...
		%		DecodingType);
		% InData - ������������������ ���, ������� ���������� ����� ����� Source
		% (ClassSource).
		% �� ������� �����, ��� ��� ���������� ���� ������� ����������� �
		% ������������� ����������� ���� ����� ���������������� ��������� 
		% ���������: 
		% Trellis - �������; ������: Trellis = poly2trellis(poly2trellis(7,[171 133]);)
		% TbDepth - traceback depth
		% DecodingType - ��� �������������: � �������� ��������� ��� � ������� ���������
		% ��� �������� ���������� ����� ���������� � �������� � Matlab.
		
		
		% ��� LDPC ���� ���������� � �������
		% https://www.mathworks.com/help/comm/ref/comm.ldpcencoder-system-object.html
		% https://www.mathworks.com/help/comm/ref/comm.ldpcdecoder-system-object.html
		
		% ������, ��� �� ������������� ��� ���� ����������� ������� ��� ����� ���� 
		% ���������� ��� ����������� ���� ����������� (���� CC, ���� LDPC).
		
		% �������:
		% 1) ���������� ������ ������������������ ������ �������� BPSK, QPSK, ...
		% QAM16 � �������������� ����������� �����������.
        % 1.1) �������� ������������������ ����� �������� ��� ��������� ��-4 � ���-16 
        % ��� ������������� ���������� ����������� � ��� ������������� ���������� ����������� 
        % ��� ��� ����� ��������� ������� (� ������� ���������, � ������� ��������� � 
        % � ������� ��������� � ��������������), ��������� �������������. 
        % ��������� ���������� ������� ������������������ ��� �����������
        % 10�4. 
        % 1.2) ����������� ����������� ������� � �������� ������������������ 
        % ��� ������������� ���������� ����������� �� ����� ��������������� 
        % ����� N = 6, N = 10, N = 100.


        % 2) ��� LDPC �����������.
        % 2.1) �������� ���������� 
		% ������ ������������������ � �������������� ������� ������������������ 
		% ������ �������� BPSK, QPSK, QAM16 � ������ ����. ��� LDPC ������� ����� 
		% �������� �������� �����������. 
        % 2.2) ������������ BER � FER � ������ ���������� � ��� ����������
        % �����������. 
		
		% 3) �� ���������� ������ ������������������ ����� �������� ����� ������������ 
		% ������������� �� ��������� �������. (�� ������ BER = 10^-3)
		
		
		% ������ ���� ��� ����������� ����
		
        % ��� ����������� (Convolution/LDPC)
            TypeEncoder;
        % �������
            Trellis;
        % tb depth
            TbDepth;
        % ��� �������������
            DecodingType;
        % ���������� ���������� ������ ������ ���������� ��� ������������
            LogLanguage;
    end
    properties (SetAccess = private) % ����������� ����������
		% ���� ���� �����-�� ���������� ����� ���������. ����� ����� ����������������
		% � ��������� �����.
			% ��� ����������� ���� �������� �������� ����������� ����� ���������
				CodeRateCC;
			% �������� �������� ����������� ����� ����� ��� ����������� ������� 
			% �������� ���� (��. ClassChannel)
    end
    methods
        function obj = ClassEncoder(Params, LogLanguage) % �����������
			% ��� �������� ���������� ����� ������ � ������� SetParams.m
			% (� ������� Encoder = SetParamsEncoder(inEncoder, ParamsNumber, ...
			% 	LogLanguage) %#ok<INUSD,DEFNU>)
			% ��� � ������� Setup.m
			
            % ������� ���� Params, ����������� ��� �������������
                Encoder  = Params.Encoder;
            % ������������� �������� ���������� �� ����������
                obj.isTransparent = Encoder.isTransparent;
            % ��� �����������
                obj.TypeEncoder = Encoder.TypeEncoder;
            % �������
                obj.Trellis = Encoder.Trellis;
            % tb depth
                obj.TbDepth = Encoder.TbDepth;
            % ��� �������������
                obj.DecodingType = Encoder.DecodingType;
			% �������� �����������
				obj.CodeRateCC = log2(obj.Trellis.numInputSymbols) / ...
					log2(obj.Trellis.numOutputSymbols);
            % ���������� LogLanguage
                obj.LogLanguage = LogLanguage;
        end
        function OutData = StepTx(obj, InData)
			
			% Source -> Coding -> Interleaving -> Modulation -> Channel
			% InData - ����� ����� Source = ���� ����� Coding
			% Output - ����� ����� Coding
			% ����������� 
			% ���� obj.isTransparent = true - ����� ��� ����� �����������, �.����
			% OutData = InData
			
            if obj.isTransparent
				% �� ���� ��� ����������� 
                OutData = InData;
                return
            end
            
			% ���� obj.isTransparent = false - ���� �����������
            % ����� ������ ���� ��������� �����������
            switch obj.TypeEncoder
                case 'Convolution'
					% ������� ����������� 
                    OutData = convenc(InData, obj.Trellis);
                case 'LDPC'
                    % Create an LDPC parity check matrix for a code rate 
                    % from the DVB-S.2 standard.
                    % 1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 5/6, 8/9, 
                    % or 9/10.
                    % Use function dvbs2ldpc(obj.CodeRate)

                    % Create System objects for the LDPC encoder using
                    % comm.LDPCEncoder
                    %    Encoder = ... ;
                    
                    % OutData
                    % OutData = Encoder(InData);
            end
            
        end
        function OutData = StepRx(obj, InData)
			% �������������
			% Demodulation -> De-Interleaving -> Decoding -> BER Calculation
            if obj.isTransparent
                OutData = InData;
                return
            end
            
            % ����� ������ ���� ��������� �������������
            switch obj.TypeEncoder
                case 'Convolution'
                    OutData = vitdec(InData, obj.Trellis, obj.TbDepth, 'trunc', obj.DecodingType);
                case 'LDPC'
                    % Create an LDPC parity check matrix for a code rate 
                    % from the DVB-S.2 standard.
                    % 1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 5/6, 8/9, 
                    % or 9/10.
                    % Use function dvbs2ldpc

                    % Create System objects for the LDPC decoder using
                    % comm.LDPCDecoder
                    %    Decoder = ... ;
                    
                    % OutData
                    % OutData = Decoder(InData);
            end
                 
        end
    end
end