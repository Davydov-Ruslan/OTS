classdef ClassSource < handle
    properties (SetAccess = private) % ���������� �� ����������
        % ���������� ��� � ����� �����
            NumBitsPerFrame;
        % ���������� ���������� ������ ������ ���������� ��� ������������
            LogLanguage;
    end
    properties (SetAccess = private) % ����������� ����������
    end
    methods
        function obj = ClassSource(Params, LogLanguage) % �����������
            % ������� ���� Params, ����������� ��� �������������
                Source  = Params.Source;
            % ������������� �������� ���������� �� ����������
                obj.NumBitsPerFrame = Source.NumBitsPerFrame;
            % ���������� LogLanguage
                obj.LogLanguage = LogLanguage;
        end
        function Bits = Step(obj)
			% ���������� ��� ������ ���� ������ Mapper.ModulationOrder. 
			% ��� LDPC ���������� ��� = 16200, 32400,64800 
			% ����� ������ � SetParams.m  ��� Setup.m
            Bits = randi(2, obj.NumBitsPerFrame, 1) - 1;
        end
    end
end