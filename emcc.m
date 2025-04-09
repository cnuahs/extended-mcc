function mcc = emcc(cm,scaleopt)
  % Extended [multiclass] Matthews Correlation Coefficient (MCC)
  %
  %   MCC = EMCC(CM[,SCALEOPT])
  %
  % where CM is a square confusion matrix and SCALEOPT is one of:
  %   'normalize' - scales MCC to [0,1], i.e., normalized MCC (nMCC).
  %   'none' - no scaling (this is the default).
  %
  % See Stoica and Babu, (2024) Pearson–Matthews correlation coefficients
  %     for binary and multinary classification. Signal Proc. 222:109511.
  %     https://doi.org/10.1016/j.sigpro.2024.109511.

  % 2025-04-04 - Shaun L. Cloherty <s.cloherty@ieee.org>

  arguments
    cm {mustBeNumeric, mustBeSquare(cm), mustBeGreaterThanOrEqual(cm,0)}
    scaleopt (1,:) char {mustBeMember(scaleopt,{'normalize','none'})} = 'none'
  end

  cm = cm + eps.*(cm == 0);

  alpha = sum(cm,2); % row totals
  beta = sum(cm,1)'; % column totals

  num = prod(diag(cm)) - sqrt(prod((alpha-diag(cm)).*(beta-diag(cm))));
  den = sqrt(prod(alpha.*beta));

  mcc = num/den;

  if strcmp(scaleopt,'none')
    return
  end
  
  % normalize
  mcc = (mcc + 1)/2;
end

function mustBeSquare(cm)
  if ~ismatrix(cm) || size(cm,1) ~= size(cm,2)
    error('Value must be a square matrix.');
  end
end