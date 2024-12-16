% function plot_set_text(axes, titleText, labelText, legendText)
%     ax = axes;% 當前座標區或圖
% 
%     set(ax.Title, 'String', titleText);
% 
%     set(ax.XLabel, 'String', labelText{1});
%     set(ax.YLabel, 'String', labelText{2});
% 
%     if nargin > 3 && ~isempty(legendText)
%         if iscell(legendText)
%             % 將元胞陣列中的每個值添加到圖例中
%             legend(ax, legendText{:});
%         else
%             % 如果不是元胞陣列，直接設置圖例
%             legend(ax, legendText);
%         end
%     end
% end
function plot_set_text(ax, titleText, labelText, legendText)
    % 檢查並設置標題
    if nargin >= 2 && ~isempty(titleText)
        set(ax.Title, 'String', titleText);
    end

    % 檢查並設置標籤
    if nargin >= 3 && ~isempty(labelText)
        if iscell(labelText) && numel(labelText) == 2
            set(ax.XLabel, 'String', labelText{1});
            set(ax.YLabel, 'String', labelText{2});
        else
            error('labelText 必須是一個包含兩個字串的元胞陣列');
        end
    end

    % 檢查並設置圖例
    if nargin >= 4 && ~isempty(legendText)
        if iscell(legendText)
            legend(ax, legendText{:});
        else
            legend(ax, legendText);
        end
    end
end
