
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Paper: Shrinking the Semantic Gap£ºSpatial Pooling of Local Moment Invariants for Copy-Move Forgery Detection
%  Programmer: Chao Wang
%  Please refer to this paper for a more detailed description of the algorithm.
%  https://arxiv.org/abs/2207.09135
%  All rights reserved.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;
warning('off');
addpath(genpath(pwd));
run('vl_setup.m')
dbstop if error
%% Setting
% Point
P_PeakTh = 0; P_EdgeTh = 50;
% Feature
F_BZ = 20;
F_sigma = 0.001;
F_K = 3;
F_NM = [0,0;1,0;2,0;3,0;... %magnitude
        0,1;1,1;2,1;3,1;... %magnitude+phase
        0,2;1,2;2,2;3,2;... %magnitude+phase
        0,3;1,3;2,3;3,3];   %magnitude+phase
% Matching
M_Dist = 100; M_2NN = 0.6; M_MM = 0.1;
% Post P.
PP_NoBin = [80,80]; PP_Count = 6; 
PP_EpsilonNB = 3; PP_MinPts = []; 
PP_BW = 0.4; PP_MinArea = 0.0001; PP_ROI_flge = 1; PP_ROI_SE = 50; PP_ROI_Num = 3; PP_FL_SZ = 15; PP_FL_std = 2; PP_SSIM_SE = 4; PP_SSIM_std = 3; PP_sigma=0.001; %Localizing
%% Input
OIName=['MICC_r30_s1200stone_ghost.png'];
GTName=['MICC_r30_s1200stone_ghost_gt.png'];
OI=imread(OIName);
GT=imread(GTName);
GI=rgb2gray(OI);
GI=double(GI);
% GT=rgb2gray(GT);
%% Enlarge
[OI,GI,flag,SZ1,SZ2]    =       Enlarge(OI,GI);
%% Point
[P,t1]                  =       Point(GI,P_PeakTh,P_EdgeTh,OI);
%% Feature [Word Level]
[F_wl,OF_wl,P_wl,t2]    =       Feature_word(GI,P,F_NM,F_BZ);
%% Matching [Word Level]
[MP_wl,MF_wl,MOF_wl,t3] =       Matching_word(F_wl,OF_wl,P_wl,M_Dist,M_2NN,M_MM,OI,F_BZ);
%% Feature [Phrase Level]
[F_pl,P_pl,OF_pl,t4]    =       Feature_phrase(MP_wl,MF_wl,MOF_wl,F_K,F_sigma,OI);
%% Matching [phrase level]
[MP_pl,MOF_pl,t5]       =       Matching_phrase(F_pl,OF_pl,P_pl,M_Dist,M_2NN,OI,F_BZ);
%% Post P.
[G,FMP,t6]              =       PostP(MP_pl,MOF_pl,PP_NoBin,PP_Count,PP_EpsilonNB,PP_MinPts,PP_BW,PP_MinArea,PP_ROI_flge,PP_ROI_SE,PP_ROI_Num,PP_FL_SZ,PP_FL_std,PP_SSIM_SE,PP_SSIM_std,PP_sigma,OI,GI,F_BZ,F_NM );
%% Restore
[G]                     =       Restore(G,flag,SZ1,SZ2);
%% Output
Output(G,GT,t1,t2,t3,t4,t5,t6,P,F_wl,MP_wl,MP_pl,FMP,OIName);

