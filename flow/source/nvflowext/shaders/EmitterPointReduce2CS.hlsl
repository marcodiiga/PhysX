// SPDX-FileCopyrightText: Copyright (c) 2014-2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//  * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//  * Neither the name of NVIDIA CORPORATION nor the names of its
//    contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
// OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include "NvFlowShader.hlsli"

#include "EmitterParams.h"

#include "EmitterPointReduceCommon.hlsli"

ConstantBuffer<EmitterPointCS_Params> gParams;
ConstantBuffer<EmitterPointCS_SubStepParams> gSubStepParams;

StructuredBuffer<float4> reduceTarget1In;
StructuredBuffer<float4> reduceCouple1In;
StructuredBuffer<float> reduceWeight1In;
StructuredBuffer<uint2> key1In;

RWStructuredBuffer<float4> reduceTarget2Out;
RWStructuredBuffer<float4> reduceCouple2Out;
RWStructuredBuffer<float> reduceWeight2Out;
RWStructuredBuffer<uint2> key2Out;

[numthreads(128, 1, 1)]
void main(uint3 dispatchThreadID : SV_DispatchThreadID, uint3 groupID : SV_GroupID)
{
    uint reduceIdx1 = (dispatchThreadID.x + (gParams.reduce2BlockIdxOffset << 7u));
    uint sthreadIdx = reduceIdx1 & 127;

    uint reducedIdx1Cmp = reduceIdx1 - sthreadIdx;
    uint2 key1Cmp = key1In[reducedIdx1Cmp];
    uint blockIdxCmp = key1Cmp.x;
    uint threadIdx1DCmp = key1Cmp.y;

    float4 targetValueSum = float4(0.f, 0.f, 0.f, 0.f);
    float4 coupleRateSum = float4(0.f, 0.f, 0.f, 0.f);
    float weightSum = 0.f;
    if (reduceIdx1 < gParams.reduceCount1)
    {
        uint2 key1 = key1In[reduceIdx1];
        uint blockIdx = key1.x;
        uint threadIdx1D = key1.y;
        if (blockIdxCmp == blockIdx && threadIdx1DCmp == threadIdx1D)
        {
            targetValueSum = reduceTarget1In[reduceIdx1];
            coupleRateSum = reduceCouple1In[reduceIdx1];
            weightSum = reduceWeight1In[reduceIdx1];
        }
    }

    emitterPointReduce(sthreadIdx, targetValueSum, coupleRateSum, weightSum);

    if (sthreadIdx < 1u)
    {
        uint reduceIdx2 = reduceIdx1 >> 7u;

        reduceTarget2Out[reduceIdx2] = targetValueSum;
        reduceCouple2Out[reduceIdx2] = coupleRateSum;
        reduceWeight2Out[reduceIdx2] = weightSum;
        key2Out[reduceIdx2] = uint2(blockIdxCmp, threadIdx1DCmp);
    }
}
