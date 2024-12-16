function plot_set_size(axes, axisFontsize , titleFontsize , labelFontsize , legendFontsize , linewidth )

% ----------------------------------- 調整整張圖 --------------------------------------------

ax = axes;% 當前座標區或圖
% set(ax,'FontName','Euclid');                             % 字體設定
set(ax,'FontSize',axisFontsize);                                            % 字體大小設定

% -------------------------------------- 調整線------------------------------------------------

set(ax.Children,'LineWidth', linewidth  )                             % 調整線條寬度


xlim tight
ylim tight
% axis equal ;

% ylim padded

YData = ax.Children.YData ;
if all(YData >= -1e-6) && all(YData <= 1e-6)
    % 如果是，則設定 Y 軸範圍為 -10^-6 到 10^-6
    ylim([-1e-6, 1e-6]);
end



% -------------------------------------- 調網格------------------------------------------------

set(ax,'XGrid','on','YGrid','on');                                               % 開網格
% set(ax,'XMinorGrid','on','YMinorGrid','on');                       % 開更密的網格

% ----------------------------------- 調整 label --------------------------------------------

set(ax.XLabel,"FontSize",labelFontsize,'FontName','Euclid','Interpreter','latex');  
set(ax.YLabel,"FontSize",labelFontsize,'FontName','Euclid','Interpreter','latex');  


% ----------------------------------- 調整 title --------------------------------------------

set(ax.Title,"VerticalAlignment","bottom","FontSize",titleFontsize,'FontName','Euclid','Interpreter','latex')

% ----------------------------------- 調整 legend --------------------------------------------

set(ax.Legend,"FontSize",legendFontsize,'FontName','Euclid','Interpreter','latex')
% set(ax.Legend,"Orientation",'horizontal')
% set(ax.Legend,'Location','northoutside')

end



%  ------------------------------- 志嘉------------------------------------------------------------

% function plot_set(varargin)
% nInputs = nargin;% 偵測輸入有幾個變數
% if nInputs ==1% 若只有一個變數就是字體大小的設定值
%     ax_FontSize = varargin{1};
% else
%     ax_FontSize = varargin{1};% 字體大小的設定值
%     Line_width = varargin{2};% 所有 plot 的線粗細設定值
% end
% ax = gca;% 當前座標區或圖
% set(ax,'FontSize',ax_FontSize);% 字體大小設定
% set(ax,'FontName','Times New Roman');% 字體設定
% set(ax,'XGrid','on','YGrid','on');% 開網格
% % set(ax,'XMinorGrid','on','YMinorGrid','on');% 開更密的網格
% ax.TitleFontSizeMultiplier=1.1;% 標題與一般文字大小的放大倍率
% ax.LabelFontSizeMultiplier =1.1;
% % ax.TitleVerticalAlignment = 'bottom' ; 
% % ylim padded
% xlim tight
% % axis equal ;
% % 所有 plot 的線粗細設定
% if nInputs == 2
% plot_num = max(size(ax.Children));% ax.Children 就是 figure 裡 plot 的線
% for i = 1: plot_num
% %     ax.Children (i).LineStyle = '-';% 統一線的樣式 (通常多條線就要不一樣)
%     ax.Children(i).LineWidth = Line_width;
% end
% end
% end