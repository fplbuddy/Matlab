function RF = RemainingFact(npert,mpert,nsteady,msteady,G)
kxs = nsteady*2*pi/G;
kys = msteady*pi;
KTwoSteady = kxs^2 + kys^2; KFourSteady = KTwoSteady^2;

kxp = npert*2*pi/G;
kyp = mpert*pi;
KTwoPert = kxp^2 + kyp^2; KFourPert = KTwoPert^2;

RF = nsteady*KFourSteady^(-1) - npert*KFourPert^(-1);
end

