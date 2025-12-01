function update_dashboard()
    set(evalin('caller','hVid'),  'CData', evalin('caller','Im_debug'));
    set(evalin('caller','hMOG'),  'CData', uint8(evalin('caller','mask_fg'))*255);
    set(evalin('caller','hGrad'), 'CData', uint8(evalin('caller','mask_grad'))*255);
    set(evalin('caller','hMix'),  'CData', uint8(evalin('caller','mask_mix'))*255);
    set(evalin('caller','hWat'),  'CData', uint8(evalin('caller','mask_ws'))*255);
    set(evalin('caller','hLine'), 'CData', evalin('caller','Im_linea'));
    set(evalin('caller','hAcc'),  'CData', evalin('caller','Im_dec_acc'));
    set(evalin('caller','hHeat'), 'CData', evalin('caller','Im_dec_acc'));

    drawnow;
    pause(0.01);
end
