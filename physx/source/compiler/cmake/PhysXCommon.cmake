## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions
## are met:
##  * Redistributions of source code must retain the above copyright
##    notice, this list of conditions and the following disclaimer.
##  * Redistributions in binary form must reproduce the above copyright
##    notice, this list of conditions and the following disclaimer in the
##    documentation and/or other materials provided with the distribution.
##  * Neither the name of NVIDIA CORPORATION nor the names of its
##    contributors may be used to endorse or promote products derived
##    from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ''AS IS'' AND ANY
## EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
## PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
## CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
## PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
## OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
## (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
## OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##
## Copyright (c) 2008-2025 NVIDIA Corporation. All rights reserved.

#
# Build PhysXCommon common
#

SET(PHYSX_SOURCE_DIR ${PHYSX_ROOT_DIR}/source)
SET(COMMON_SRC_DIR ${PHYSX_SOURCE_DIR}/common/src)
SET(COMMON_INCLUDE_DIR ${PHYSX_SOURCE_DIR}/common/include)
SET(GU_SOURCE_DIR ${PHYSX_SOURCE_DIR}/geomutils)

SET(PXCOMMON_PLATFORM_LINK_FLAGS_DEBUG " ")
SET(PXCOMMON_PLATFORM_LINK_FLAGS_CHECKED " ")
SET(PXCOMMON_PLATFORM_LINK_FLAGS_PROFILE " ")
SET(PXCOMMON_PLATFORM_LINK_FLAGS_RELEASE " ")

# Include here after the directories are defined so that the platform specific file can use the variables.
include(${PHYSX_ROOT_DIR}/${PROJECT_CMAKE_FILES_DIR}/${TARGET_BUILD_PLATFORM}/PhysXCommon.cmake)


SET(PHYSX_COMMON_SOURCE
	${COMMON_SRC_DIR}/CmPtrTable.cpp
	${COMMON_SRC_DIR}/CmRenderBuffer.h
	${COMMON_SRC_DIR}/CmBlockArray.h
	${COMMON_SRC_DIR}/CmCollection.h
	${COMMON_SRC_DIR}/CmCollection.cpp
	${COMMON_SRC_DIR}/CmConeLimitHelper.h
	${COMMON_SRC_DIR}/CmFlushPool.h
	${COMMON_SRC_DIR}/CmIDPool.h
	${COMMON_SRC_DIR}/CmMatrix34.h
	${COMMON_SRC_DIR}/CmPool.h
	${COMMON_SRC_DIR}/CmPreallocatingPool.h
	${COMMON_SRC_DIR}/CmPriorityQueue.h
	${COMMON_SRC_DIR}/CmPtrTable.h
	${COMMON_SRC_DIR}/CmRadixSort.h
	${COMMON_SRC_DIR}/CmRadixSort.cpp
	${COMMON_SRC_DIR}/CmRandom.h
	${COMMON_SRC_DIR}/CmRefCountable.h
	${COMMON_SRC_DIR}/CmScaling.h
	${COMMON_SRC_DIR}/CmSerialize.h
	${COMMON_SRC_DIR}/CmSerialize.cpp
	${COMMON_SRC_DIR}/CmSpatialVector.h
	${COMMON_SRC_DIR}/CmTask.h
	${COMMON_SRC_DIR}/CmTransformUtils.h
	${COMMON_SRC_DIR}/CmUtils.h
	${COMMON_SRC_DIR}/CmVisualization.h
	${COMMON_SRC_DIR}/CmVisualization.cpp
)
SOURCE_GROUP(common\\src FILES ${PHYSX_COMMON_SOURCE})

SET(PHYSXCOMMON_COMMON_INTERNAL_HEADERS
	${COMMON_INCLUDE_DIR}/omnipvd/CmOmniPvdAutoGenClearDefines.h
	${COMMON_INCLUDE_DIR}/omnipvd/CmOmniPvdAutoGenCreateRegistrationStruct.h
	${COMMON_INCLUDE_DIR}/omnipvd/CmOmniPvdAutoGenRegisterData.h
	${COMMON_INCLUDE_DIR}/omnipvd/CmOmniPvdAutoGenSetData.h
)
SOURCE_GROUP(common\\include\\omnipvd FILES ${PHYSXCOMMON_COMMON_INTERNAL_HEADERS})

SET(PHYSXCOMMON_COMMON_HEADERS
	${PHYSX_ROOT_DIR}/include/common/PxBase.h
	${PHYSX_ROOT_DIR}/include/common/PxCollection.h
	${PHYSX_ROOT_DIR}/include/common/PxCoreUtilityTypes.h
	${PHYSX_ROOT_DIR}/include/common/PxInsertionCallback.h
	${PHYSX_ROOT_DIR}/include/common/PxPhysXCommonConfig.h
	${PHYSX_ROOT_DIR}/include/common/PxRenderBuffer.h
	${PHYSX_ROOT_DIR}/include/common/PxRenderOutput.h
	${PHYSX_ROOT_DIR}/include/common/PxSerialFramework.h
	${PHYSX_ROOT_DIR}/include/common/PxSerializer.h
	${PHYSX_ROOT_DIR}/include/common/PxStringTable.h
	${PHYSX_ROOT_DIR}/include/common/PxTolerancesScale.h
	${PHYSX_ROOT_DIR}/include/common/PxTypeInfo.h
	${PHYSX_ROOT_DIR}/include/common/PxProfileZone.h
)
SOURCE_GROUP(include\\common FILES ${PHYSXCOMMON_COMMON_HEADERS})

SET(PHYSXCOMMON_GEOMETRY_HEADERS
	${PHYSX_ROOT_DIR}/include/geometry/PxBoxGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxCapsuleGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxConvexMesh.h
	${PHYSX_ROOT_DIR}/include/geometry/PxConvexMeshGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxCustomGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxConvexCoreGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxGeometryInternal.h
	${PHYSX_ROOT_DIR}/include/geometry/PxGeometryHelpers.h
	${PHYSX_ROOT_DIR}/include/geometry/PxGeometryHit.h
	${PHYSX_ROOT_DIR}/include/geometry/PxGeometryQuery.h
	${PHYSX_ROOT_DIR}/include/geometry/PxGeometryQueryFlags.h
	${PHYSX_ROOT_DIR}/include/geometry/PxGeometryQueryContext.h
	${PHYSX_ROOT_DIR}/include/geometry/PxHeightField.h
	${PHYSX_ROOT_DIR}/include/geometry/PxHeightFieldDesc.h
	${PHYSX_ROOT_DIR}/include/geometry/PxHeightFieldFlag.h
	${PHYSX_ROOT_DIR}/include/geometry/PxHeightFieldGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxHeightFieldSample.h
	${PHYSX_ROOT_DIR}/include/geometry/PxMeshQuery.h
	${PHYSX_ROOT_DIR}/include/geometry/PxMeshScale.h
	${PHYSX_ROOT_DIR}/include/geometry/PxPlaneGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxReportCallback.h
	${PHYSX_ROOT_DIR}/include/geometry/PxSimpleTriangleMesh.h
	${PHYSX_ROOT_DIR}/include/geometry/PxSphereGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxTriangle.h
	${PHYSX_ROOT_DIR}/include/geometry/PxTriangleMesh.h
	${PHYSX_ROOT_DIR}/include/geometry/PxTriangleMeshGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxBVH.h
	${PHYSX_ROOT_DIR}/include/geometry/PxBVHBuildStrategy.h
	${PHYSX_ROOT_DIR}/include/geometry/PxTetrahedron.h
	${PHYSX_ROOT_DIR}/include/geometry/PxTetrahedronMesh.h
	${PHYSX_ROOT_DIR}/include/geometry/PxTetrahedronMeshGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxParticleSystemGeometry.h
	${PHYSX_ROOT_DIR}/include/geometry/PxGjkQuery.h
)
SOURCE_GROUP(include\\geometry FILES ${PHYSXCOMMON_GEOMETRY_HEADERS})

SET(PHYSXCOMMON_GEOMUTILS_HEADERS
	${PHYSX_ROOT_DIR}/include/geomutils/PxContactBuffer.h
	${PHYSX_ROOT_DIR}/include/geomutils/PxContactPoint.h
)
SOURCE_GROUP(include\\geomutils FILES ${PHYSXCOMMON_GEOMUTILS_HEADERS})

SET(PHYSXCOMMON_COLLISION_HEADERS
	${PHYSX_ROOT_DIR}/include/collision/PxCollisionDefs.h
)
SOURCE_GROUP(include\\collision FILES ${PHYSXCOMMON_COLLISION_HEADERS})

SET(PHYSXCOMMON_GU_HEADERS
	${GU_SOURCE_DIR}/include/GuBox.h
	${GU_SOURCE_DIR}/include/GuSphere.h
	${GU_SOURCE_DIR}/include/GuSegment.h
	${GU_SOURCE_DIR}/include/GuCapsule.h
	${GU_SOURCE_DIR}/include/GuCenterExtents.h
	${GU_SOURCE_DIR}/include/GuBounds.h
	${GU_SOURCE_DIR}/include/GuDistanceSegmentBox.h
	${GU_SOURCE_DIR}/include/GuDistanceSegmentSegment.h
	${GU_SOURCE_DIR}/include/GuIntersectionBoxBox.h
	${GU_SOURCE_DIR}/include/GuIntersectionTetrahedronBox.h
	${GU_SOURCE_DIR}/include/GuIntersectionTriangleBoxRef.h
	${GU_SOURCE_DIR}/include/GuIntersectionTriangleTriangle.h
	${GU_SOURCE_DIR}/include/GuRaycastTests.h
	${GU_SOURCE_DIR}/include/GuOverlapTests.h
	${GU_SOURCE_DIR}/include/GuSweepTests.h
	${GU_SOURCE_DIR}/include/GuCachedFuncs.h
	${GU_SOURCE_DIR}/include/GuPruner.h
	${GU_SOURCE_DIR}/include/GuPrunerTypedef.h
	${GU_SOURCE_DIR}/include/GuPrunerPayload.h
	${GU_SOURCE_DIR}/include/GuPrunerMergeData.h
	${GU_SOURCE_DIR}/include/GuSqInternal.h
	${GU_SOURCE_DIR}/include/GuActorShapeMap.h
	${GU_SOURCE_DIR}/include/GuQuerySystem.h
	${GU_SOURCE_DIR}/include/GuFactory.h
	${GU_SOURCE_DIR}/include/GuDistancePointTetrahedron.h
	${GU_SOURCE_DIR}/include/GuDistancePointTriangle.h
	${GU_SOURCE_DIR}/include/GuIntersectionTriangleBox.h
	${GU_SOURCE_DIR}/include/GuIntersectionTetrahedronTetrahedron.h
	${GU_SOURCE_DIR}/include/GuCooking.h
	${GU_SOURCE_DIR}/include/GuConvexSupport.h
	${GU_SOURCE_DIR}/include/GuConvexGeometry.h
	${GU_SOURCE_DIR}/include/GuRefGjkEpa.h
)
SOURCE_GROUP(geomutils\\include FILES ${PHYSXCOMMON_GU_HEADERS})

#SET(PHYSXCOMMON_GU_PXHEADERS
#	${PHYSX_ROOT_DIR}/include/geomutils/GuContactBuffer.h
#	${PHYSX_ROOT_DIR}/include/geomutils/GuContactPoint.h
#)
#SOURCE_GROUP(geomutils\\include FILES ${PHYSXCOMMON_GU_PXHEADERS})

SET(PHYSXCOMMON_GU_SOURCE
	${GU_SOURCE_DIR}/src/GuBox.cpp
	${GU_SOURCE_DIR}/src/GuCapsule.cpp
	${GU_SOURCE_DIR}/src/GuCCTSweepTests.cpp
	${GU_SOURCE_DIR}/src/GuGeometryQuery.cpp
	${GU_SOURCE_DIR}/src/GuInternal.cpp
	${GU_SOURCE_DIR}/src/GuMeshFactory.cpp
	${GU_SOURCE_DIR}/src/GuMTD.cpp
	${GU_SOURCE_DIR}/src/GuOverlapTests.cpp
	${GU_SOURCE_DIR}/src/GuRaycastTests.cpp
	${GU_SOURCE_DIR}/src/GuSweepMTD.cpp
	${GU_SOURCE_DIR}/src/GuSweepSharedTests.cpp
	${GU_SOURCE_DIR}/src/GuSweepTests.cpp
	${GU_SOURCE_DIR}/src/GuGeometryChecks.h
	${GU_SOURCE_DIR}/src/GuInternal.h
	${GU_SOURCE_DIR}/src/GuMeshFactory.h
	${GU_SOURCE_DIR}/src/GuMTD.h
	${GU_SOURCE_DIR}/src/GuSweepMTD.h
	${GU_SOURCE_DIR}/src/GuSweepSharedTests.h
	${GU_SOURCE_DIR}/src/GuSDF.h
	${GU_SOURCE_DIR}/src/GuSDF.cpp
	${GU_SOURCE_DIR}/src/GuGjkQuery.cpp
	${GU_SOURCE_DIR}/src/GuWindingNumber.cpp
	${GU_SOURCE_DIR}/src/GuWindingNumber.h
	${GU_SOURCE_DIR}/src/GuWindingNumberCluster.h
	${GU_SOURCE_DIR}/src/GuWindingNumberT.h
	${GU_SOURCE_DIR}/src/GuConvexGeometry.cpp
	${GU_SOURCE_DIR}/src/GuConvexSupport.cpp
)
SOURCE_GROUP(geomutils\\src FILES ${PHYSXCOMMON_GU_SOURCE})

SET(PHYSXCOMMON_GU_CCD_SOURCE
	${GU_SOURCE_DIR}/src/ccd/GuCCDSweepConvexMesh.cpp
	${GU_SOURCE_DIR}/src/ccd/GuCCDSweepPrimitives.cpp
	${GU_SOURCE_DIR}/src/ccd/GuCCDSweepConvexMesh.h
)
SOURCE_GROUP(geomutils\\src\\ccd FILES ${PHYSXCOMMON_GU_CCD_SOURCE})

SET(PHYSXCOMMON_GU_COMMON_SOURCE
	${GU_SOURCE_DIR}/src/common/GuBarycentricCoordinates.cpp
	${GU_SOURCE_DIR}/src/common/GuBarycentricCoordinates.h
	${GU_SOURCE_DIR}/src/common/GuBoxConversion.h
	${GU_SOURCE_DIR}/src/common/GuEdgeCache.h
	${GU_SOURCE_DIR}/src/common/GuAdjacencies.h
	${GU_SOURCE_DIR}/src/common/GuAdjacencies.cpp
	${GU_SOURCE_DIR}/src/common/GuEdgeList.h
	${GU_SOURCE_DIR}/src/common/GuEdgeList.cpp
	${GU_SOURCE_DIR}/src/common/GuSeparatingAxes.h
	${GU_SOURCE_DIR}/src/common/GuSeparatingAxes.cpp
	${GU_SOURCE_DIR}/src/common/GuQuantizer.h
	${GU_SOURCE_DIR}/src/common/GuQuantizer.cpp
	${GU_SOURCE_DIR}/src/common/GuMeshCleaner.h
	${GU_SOURCE_DIR}/src/common/GuMeshCleaner.cpp
	${GU_SOURCE_DIR}/src/common/GuVertexReducer.h
	${GU_SOURCE_DIR}/src/common/GuVertexReducer.cpp
    ${GU_SOURCE_DIR}/src/common/GuMeshAnalysis.h
	${GU_SOURCE_DIR}/src/common/GuMeshAnalysis.cpp
)
SOURCE_GROUP(geomutils\\src\\common FILES ${PHYSXCOMMON_GU_COMMON_SOURCE})

SET(PHYSXCOMMON_GU_CONTACT_SOURCE
	${GU_SOURCE_DIR}/src/contact/GuContactBoxBox.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactCapsuleBox.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactCapsuleCapsule.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactCapsuleConvex.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactCapsuleMesh.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactConvexConvex.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactConvexMesh.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactConvexCoreMesh.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactConvexCoreConvex.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactPlaneConvexCore.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactPlaneBox.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactPlaneCapsule.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactPlaneConvex.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactPlaneMesh.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactPolygonPolygon.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactMeshMesh.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactMeshMesh.h
	${GU_SOURCE_DIR}/src/contact/GuContactReduction.h
	${GU_SOURCE_DIR}/src/contact/GuCollisionSDF.h
	${GU_SOURCE_DIR}/src/contact/GuContactSphereBox.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactSphereCapsule.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactSphereMesh.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactSpherePlane.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactSphereSphere.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactCustomGeometry.cpp
	${GU_SOURCE_DIR}/src/contact/GuFeatureCode.cpp
	${GU_SOURCE_DIR}/src/contact/GuContactMethodImpl.h
	${GU_SOURCE_DIR}/src/contact/GuContactPolygonPolygon.h
	${GU_SOURCE_DIR}/src/contact/GuFeatureCode.h
)
SOURCE_GROUP(geomutils\\src\\contact FILES ${PHYSXCOMMON_GU_CONTACT_SOURCE})

SET(PHYSXCOMMON_GU_CONVEX_SOURCE
	${GU_SOURCE_DIR}/src/convex/GuBigConvexData.cpp
	${GU_SOURCE_DIR}/src/convex/GuConvexHelper.cpp
	${GU_SOURCE_DIR}/src/convex/GuConvexMesh.cpp
	${GU_SOURCE_DIR}/src/convex/GuConvexSupportTable.cpp
	${GU_SOURCE_DIR}/src/convex/GuConvexUtilsInternal.cpp
	${GU_SOURCE_DIR}/src/convex/GuHillClimbing.cpp
	${GU_SOURCE_DIR}/src/convex/GuShapeConvex.cpp
	${GU_SOURCE_DIR}/src/convex/GuBigConvexData.h
	${GU_SOURCE_DIR}/src/convex/GuBigConvexData2.h
	${GU_SOURCE_DIR}/src/convex/GuConvexEdgeFlags.h
	${GU_SOURCE_DIR}/src/convex/GuConvexHelper.h
	${GU_SOURCE_DIR}/src/convex/GuConvexMesh.h
	${GU_SOURCE_DIR}/src/convex/GuConvexMeshData.h
	${GU_SOURCE_DIR}/src/convex/GuConvexSupportTable.h
	${GU_SOURCE_DIR}/src/convex/GuConvexUtilsInternal.h
	${GU_SOURCE_DIR}/src/convex/GuCubeIndex.h
	${GU_SOURCE_DIR}/src/convex/GuHillClimbing.h
	${GU_SOURCE_DIR}/src/convex/GuShapeConvex.h
)
SOURCE_GROUP(geomutils\\src\\convex FILES ${PHYSXCOMMON_GU_CONVEX_SOURCE})

SET(PHYSXCOMMON_GU_DISTANCE_SOURCE
	${GU_SOURCE_DIR}/src/distance/GuDistancePointBox.cpp
	${GU_SOURCE_DIR}/src/distance/GuDistancePointTriangle.cpp
	${GU_SOURCE_DIR}/src/distance/GuDistanceSegmentBox.cpp
	${GU_SOURCE_DIR}/src/distance/GuDistanceSegmentSegment.cpp
	${GU_SOURCE_DIR}/src/distance/GuDistanceSegmentTriangle.cpp
	${GU_SOURCE_DIR}/src/distance/GuDistanceTriangleTriangle.cpp
	${GU_SOURCE_DIR}/src/distance/GuDistancePointTetrahedron.cpp
	${GU_SOURCE_DIR}/src/distance/GuDistancePointBox.h
	${GU_SOURCE_DIR}/src/distance/GuDistancePointSegment.h
	${GU_SOURCE_DIR}/src/distance/GuDistanceSegmentTriangle.h
	${GU_SOURCE_DIR}/src/distance/GuDistanceTriangleTriangle.h
)
SOURCE_GROUP(geomutils\\src\\distance FILES ${PHYSXCOMMON_GU_DISTANCE_SOURCE})

SET(PHYSXCOMMON_GU_GJK_SOURCE
	${GU_SOURCE_DIR}/src/gjk/GuEPA.cpp
	${GU_SOURCE_DIR}/src/gjk/GuGJKSimplex.cpp
	${GU_SOURCE_DIR}/src/gjk/GuGJKTest.cpp
	${GU_SOURCE_DIR}/src/gjk/GuEPA.h
	${GU_SOURCE_DIR}/src/gjk/GuEPAFacet.h
	${GU_SOURCE_DIR}/src/gjk/GuGJK.h
	${GU_SOURCE_DIR}/src/gjk/GuGJKPenetration.h
	${GU_SOURCE_DIR}/src/gjk/GuGJKRaycast.h
	${GU_SOURCE_DIR}/src/gjk/GuGJKSimplex.h
	${GU_SOURCE_DIR}/src/gjk/GuGJKTest.h
	${GU_SOURCE_DIR}/src/gjk/GuGJKType.h
	${GU_SOURCE_DIR}/src/gjk/GuGJKUtil.h
	${GU_SOURCE_DIR}/src/gjk/GuVecBox.h
	${GU_SOURCE_DIR}/src/gjk/GuVecCapsule.h
	${GU_SOURCE_DIR}/src/gjk/GuVecConvex.h
	${GU_SOURCE_DIR}/src/gjk/GuVecConvexHull.h
	${GU_SOURCE_DIR}/src/gjk/GuVecConvexHullNoScale.h
	${GU_SOURCE_DIR}/src/gjk/GuVecPlane.h
	${GU_SOURCE_DIR}/src/gjk/GuVecSphere.h
	${GU_SOURCE_DIR}/src/gjk/GuVecTriangle.h
	${GU_SOURCE_DIR}/src/gjk/GuVecTetrahedron.h
)
SOURCE_GROUP(geomutils\\src\\gjk FILES ${PHYSXCOMMON_GU_GJK_SOURCE})

SET(PHYSXCOMMON_GU_HF_SOURCE
	${GU_SOURCE_DIR}/src/hf/GuHeightField.cpp
	${GU_SOURCE_DIR}/src/hf/GuHeightFieldUtil.cpp
	${GU_SOURCE_DIR}/src/hf/GuOverlapTestsHF.cpp
	${GU_SOURCE_DIR}/src/hf/GuSweepsHF.cpp
	${GU_SOURCE_DIR}/src/hf/GuEntityReport.h
	${GU_SOURCE_DIR}/src/hf/GuHeightField.h
	${GU_SOURCE_DIR}/src/hf/GuHeightFieldData.h
	${GU_SOURCE_DIR}/src/hf/GuHeightFieldUtil.h
)
SOURCE_GROUP(geomutils\\src\\hf FILES ${PHYSXCOMMON_GU_HF_SOURCE})

SET(PHYSXCOMMON_GU_INTERSECTION_SOURCE
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionBoxBox.cpp
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionCapsuleTriangle.cpp
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionEdgeEdge.cpp
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionRayBox.cpp
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionRayCapsule.cpp
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionRaySphere.cpp
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionSphereBox.cpp
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionTetrahedronBox.cpp
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionTriangleBox.cpp
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionTriangleTriangle.cpp
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionCapsuleTriangle.h
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionEdgeEdge.h
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionRay.h
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionRayBox.h
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionRayCapsule.h
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionRayPlane.h
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionRaySphere.h
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionRayTriangle.h
	${GU_SOURCE_DIR}/src/intersection/GuIntersectionSphereBox.h
)
SOURCE_GROUP(geomutils\\src\\intersection FILES ${PHYSXCOMMON_GU_INTERSECTION_SOURCE})

SET(PXCOMMON_BVH4_FILES
	${GU_SOURCE_DIR}/src/mesh/GuBV4_AABBSweep.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV4_BoxOverlap.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV4_CapsuleSweep.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV4_CapsuleSweepAA.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV4_MeshMeshOverlap.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV4_OBBSweep.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV4_Raycast.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV4_SphereOverlap.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV4_SphereSweep.cpp
	${GU_SOURCE_DIR}/src/mesh/GuMidphaseBV4.cpp
)

SET(PHYSXCOMMON_GU_MESH_SOURCE
	${GU_SOURCE_DIR}/src/mesh/GuBV4.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV4Build.cpp

	${PXCOMMON_BVH4_FILES}

	${GU_SOURCE_DIR}/src/mesh/GuMeshQuery.cpp
	${GU_SOURCE_DIR}/src/mesh/GuMidphaseRTree.cpp
	${GU_SOURCE_DIR}/src/mesh/GuOverlapTestsMesh.cpp
	${GU_SOURCE_DIR}/src/mesh/GuRTree.cpp
	${GU_SOURCE_DIR}/src/mesh/GuRTreeQueries.cpp
	${GU_SOURCE_DIR}/src/mesh/GuSweepsMesh.cpp
	${GU_SOURCE_DIR}/src/mesh/GuTriangleMesh.cpp
	${GU_SOURCE_DIR}/src/mesh/GuTriangleMeshBV4.cpp
	${GU_SOURCE_DIR}/src/mesh/GuTriangleMeshRTree.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV32.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV32Build.cpp
	${GU_SOURCE_DIR}/src/mesh/GuTetrahedronMesh.cpp
	${GU_SOURCE_DIR}/src/mesh/GuTetrahedronMeshUtils.cpp
	${GU_SOURCE_DIR}/src/mesh/GuBV32.h
	${GU_SOURCE_DIR}/src/mesh/GuBV32Build.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4Build.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4Settings.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_AABBAABBSweepTest.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_BoxBoxOverlapTest.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_BoxOverlap_Internal.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_BoxSweep_Internal.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_BoxSweep_Params.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_CapsuleSweep_Internal.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_Common.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_Internal.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_ProcessStreamNoOrder_OBBOBB.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_ProcessStreamNoOrder_SegmentAABB.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_ProcessStreamNoOrder_SegmentAABB_Inflated.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_ProcessStreamNoOrder_SphereAABB.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_ProcessStreamOrdered_OBBOBB.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_ProcessStreamOrdered_SegmentAABB.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_ProcessStreamOrdered_SegmentAABB_Inflated.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_Slabs.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_Slabs_KajiyaNoOrder.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_Slabs_KajiyaOrdered.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_Slabs_SwizzledNoOrder.h
	${GU_SOURCE_DIR}/src/mesh/GuBV4_Slabs_SwizzledOrdered.h
	${GU_SOURCE_DIR}/src/mesh/GuBVConstants.h
	${GU_SOURCE_DIR}/src/mesh/GuMeshData.h
	${GU_SOURCE_DIR}/src/mesh/GuMidphaseInterface.h
	${GU_SOURCE_DIR}/src/mesh/GuRTree.h
	${GU_SOURCE_DIR}/src/mesh/GuSweepConvexTri.h
	${GU_SOURCE_DIR}/src/mesh/GuSweepMesh.h
	${GU_SOURCE_DIR}/src/mesh/GuTriangle.h
	${GU_SOURCE_DIR}/src/mesh/GuTriangleCache.h
	${GU_SOURCE_DIR}/src/mesh/GuTriangleMesh.h
	${GU_SOURCE_DIR}/src/mesh/GuTriangleMeshBV4.h
	${GU_SOURCE_DIR}/src/mesh/GuTriangleMeshRTree.h
	${GU_SOURCE_DIR}/src/mesh/GuTetrahedron.h
	${GU_SOURCE_DIR}/src/mesh/GuTetrahedronMesh.h
	${GU_SOURCE_DIR}/src/mesh/GuTetrahedronMeshUtils.h
	${GU_SOURCE_DIR}/src/mesh/GuTriangleRefinement.h
)
SOURCE_GROUP(geomutils\\src\\mesh FILES ${PHYSXCOMMON_GU_MESH_SOURCE})

SET(PHYSXCOMMON_GU_PCM_SOURCE
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactBoxBox.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactBoxConvex.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactCapsuleBox.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactCapsuleCapsule.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactCapsuleConvex.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactCapsuleHeightField.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactCapsuleMesh.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactConvexCommon.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactConvexConvex.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactConvexHeightField.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactConvexMesh.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactGenBoxConvex.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactGenSphereCapsule.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactPlaneBox.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactPlaneCapsule.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactPlaneConvex.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactSphereBox.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactSphereCapsule.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactSphereConvex.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactSphereHeightField.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactSphereMesh.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactSpherePlane.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactSphereSphere.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactCustomGeometry.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMShapeConvex.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMTriangleContactGen.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPersistentContactManifold.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactConvexCommon.h
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactGen.h
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactGenUtil.h
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactGenUtil.cpp
	${GU_SOURCE_DIR}/src/pcm/GuPCMContactMeshCallback.h
	${GU_SOURCE_DIR}/src/pcm/GuPCMShapeConvex.h
	${GU_SOURCE_DIR}/src/pcm/GuPCMTriangleContactGen.h
	${GU_SOURCE_DIR}/src/pcm/GuPersistentContactManifold.h
)
SOURCE_GROUP(geomutils\\src\\pcm FILES ${PHYSXCOMMON_GU_PCM_SOURCE})

SET(PHYSXCOMMON_GU_SWEEP_SOURCE
	${GU_SOURCE_DIR}/src/sweep/GuSweepBoxBox.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepBoxSphere.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepBoxTriangle_FeatureBased.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepBoxTriangle_SAT.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepCapsuleBox.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepCapsuleCapsule.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepCapsuleTriangle.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepSphereCapsule.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepSphereSphere.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepSphereTriangle.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepTriangleUtils.cpp
	${GU_SOURCE_DIR}/src/sweep/GuSweepBoxBox.h
	${GU_SOURCE_DIR}/src/sweep/GuSweepBoxSphere.h
	${GU_SOURCE_DIR}/src/sweep/GuSweepBoxTriangle_FeatureBased.h
	${GU_SOURCE_DIR}/src/sweep/GuSweepBoxTriangle_SAT.h
	${GU_SOURCE_DIR}/src/sweep/GuSweepCapsuleBox.h
	${GU_SOURCE_DIR}/src/sweep/GuSweepCapsuleCapsule.h
	${GU_SOURCE_DIR}/src/sweep/GuSweepCapsuleTriangle.h
	${GU_SOURCE_DIR}/src/sweep/GuSweepSphereCapsule.h
	${GU_SOURCE_DIR}/src/sweep/GuSweepSphereSphere.h
	${GU_SOURCE_DIR}/src/sweep/GuSweepSphereTriangle.h
	${GU_SOURCE_DIR}/src/sweep/GuSweepTriangleUtils.h
)
SOURCE_GROUP(geomutils\\src\\sweep FILES ${PHYSXCOMMON_GU_SWEEP_SOURCE})

SET(PHYSXCOMMON_GU_PRUNERS_SOURCE
	${GU_SOURCE_DIR}/src/GuBounds.cpp
	${GU_SOURCE_DIR}/src/GuQuery.h
	${GU_SOURCE_DIR}/src/GuAABBTree.cpp
	${GU_SOURCE_DIR}/src/GuAABBTree.h
	${GU_SOURCE_DIR}/src/GuAABBTreeUpdateMap.h
	${GU_SOURCE_DIR}/src/GuAABBTreeUpdateMap.cpp
	${GU_SOURCE_DIR}/src/GuAABBTreeBounds.h
	${GU_SOURCE_DIR}/src/GuAABBTreeNode.h
	${GU_SOURCE_DIR}/src/GuAABBTreeBuildStats.h
	${GU_SOURCE_DIR}/src/GuAABBTreeQuery.h
	${GU_SOURCE_DIR}/src/GuSqInternal.cpp
	${GU_SOURCE_DIR}/src/GuIncrementalAABBTree.h
	${GU_SOURCE_DIR}/src/GuIncrementalAABBTree.cpp
	${GU_SOURCE_DIR}/src/GuSAH.cpp
	${GU_SOURCE_DIR}/src/GuSAH.h
	${GU_SOURCE_DIR}/src/GuBVH.cpp
	${GU_SOURCE_DIR}/src/GuBVH.h
	${GU_SOURCE_DIR}/src/GuBVHTestsSIMD.h
	${GU_SOURCE_DIR}/src/GuIncrementalAABBPrunerCore.h
	${GU_SOURCE_DIR}/src/GuIncrementalAABBPrunerCore.cpp
	${GU_SOURCE_DIR}/src/GuIncrementalAABBPruner.h
	${GU_SOURCE_DIR}/src/GuIncrementalAABBPruner.cpp
	${GU_SOURCE_DIR}/src/GuPruningPool.h
	${GU_SOURCE_DIR}/src/GuPruningPool.cpp
	${GU_SOURCE_DIR}/src/GuBucketPruner.h
	${GU_SOURCE_DIR}/src/GuBucketPruner.cpp
	${GU_SOURCE_DIR}/src/GuMaverickNode.h
	${GU_SOURCE_DIR}/src/GuMaverickNode.cpp
	${GU_SOURCE_DIR}/src/GuExtendedBucketPruner.h
	${GU_SOURCE_DIR}/src/GuExtendedBucketPruner.cpp
	${GU_SOURCE_DIR}/src/GuSecondaryPruner.h
	${GU_SOURCE_DIR}/src/GuSecondaryPruner.cpp
	${GU_SOURCE_DIR}/src/GuAABBPruner.h
	${GU_SOURCE_DIR}/src/GuAABBPruner.cpp
	${GU_SOURCE_DIR}/src/GuActorShapeMap.cpp
	${GU_SOURCE_DIR}/src/GuCallbackAdapter.h
	${GU_SOURCE_DIR}/src/GuQuerySystem.cpp
	${GU_SOURCE_DIR}/src/GuFactory.cpp
)
SOURCE_GROUP(geomutils\\src\\pruners FILES ${PHYSXCOMMON_GU_PRUNERS_SOURCE})

SET(PHYSXCOMMON_GU_COOKING_SOURCE
	${GU_SOURCE_DIR}/src/cooking/GuRTreeCooking.h
	${GU_SOURCE_DIR}/src/cooking/GuRTreeCooking.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingBVH.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingHF.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingGrbTriangleMesh.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexMesh.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingTriangleMesh.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingTriangleMesh.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingTetrahedronMesh.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingTetrahedronMesh.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingVolumeIntegration.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingVolumeIntegration.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingQuickHullConvexHullLib.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingQuickHullConvexHullLib.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexPolygonsBuilder.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexPolygonsBuilder.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexMeshBuilder.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexMeshBuilder.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexHullUtils.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexHullUtils.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexHullLib.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexHullLib.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexHullBuilder.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingConvexHullBuilder.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingBigConvexDataBuilder.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingBigConvexDataBuilder.cpp
	${GU_SOURCE_DIR}/src/cooking/GuCookingSDF.h
	${GU_SOURCE_DIR}/src/cooking/GuCookingSDF.cpp
)
SOURCE_GROUP(geomutils\\src\\cooking FILES ${PHYSXCOMMON_GU_COOKING_SOURCE})

ADD_LIBRARY(PhysXCommon ${PHYSXCOMMON_LIBTYPE}
	${PHYSX_COMMON_SOURCE}
    ${PHYSXCOMMON_COMMON_INTERNAL_HEADERS}

	${PHYSXCOMMON_COMMON_HEADERS}
	${PHYSXCOMMON_GEOMETRY_HEADERS}
	${PHYSXCOMMON_GEOMUTILS_HEADERS}
	${PHYSXCOMMON_COLLISION_HEADERS}

	${PXCOMMON_PLATFORM_SRC_FILES}

	${PHYSXCOMMON_GU_HEADERS}
#	${PHYSXCOMMON_GU_PXHEADERS}

	${PHYSXCOMMON_GU_SOURCE}
	${PHYSXCOMMON_GU_CCD_SOURCE}
	${PHYSXCOMMON_GU_COMMON_SOURCE}
	${PHYSXCOMMON_GU_CONTACT_SOURCE}
	${PHYSXCOMMON_GU_CONVEX_SOURCE}
	${PHYSXCOMMON_GU_DISTANCE_SOURCE}
	${PHYSXCOMMON_GU_GJK_SOURCE}
	${PHYSXCOMMON_GU_HF_SOURCE}
	${PHYSXCOMMON_GU_INTERSECTION_SOURCE}
	${PHYSXCOMMON_GU_MESH_SOURCE}
	${PHYSXCOMMON_GU_PCM_SOURCE}
	${PHYSXCOMMON_GU_SWEEP_SOURCE}
	${PHYSXCOMMON_GU_PRUNERS_SOURCE}
	${PHYSXCOMMON_GU_COOKING_SOURCE}
)

if(NOT DEFINED PX_ENABLE_INSTALL OR (DEFINED PX_ENABLE_INSTALL AND PX_ENABLE_INSTALL))
	INSTALL(FILES ${PHYSXCOMMON_GEOMETRY_HEADERS} DESTINATION include/geometry)
	INSTALL(FILES ${PHYSXCOMMON_GEOMUTILS_HEADERS} DESTINATION include/geomutils)
endif()

TARGET_INCLUDE_DIRECTORIES(PhysXCommon
	PRIVATE ${PXCOMMON_PLATFORM_INCLUDES}

	PUBLIC ${PHYSX_ROOT_DIR}/include

	PRIVATE ${PHYSX_SOURCE_DIR}/common/include
	PRIVATE ${PHYSX_SOURCE_DIR}/common/src

	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/include
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/contact
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/common
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/convex
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/distance
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/sweep
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/gjk
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/intersection
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/mesh
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/hf
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/pcm
	PRIVATE ${PHYSX_SOURCE_DIR}/geomutils/src/ccd

	PRIVATE ${PHYSX_SOURCE_DIR}/physxgpu/include
)

TARGET_COMPILE_DEFINITIONS(PhysXCommon
	PRIVATE ${PXCOMMON_COMPILE_DEFS}
)

SET_TARGET_PROPERTIES(PhysXCommon PROPERTIES
	OUTPUT_NAME PhysXCommon
)


IF(PHYSXCOMMON_LIBTYPE STREQUAL "STATIC")
	SET_TARGET_PROPERTIES(PhysXCommon PROPERTIES
		ARCHIVE_OUTPUT_NAME_DEBUG "PhysXCommon_static"
		ARCHIVE_OUTPUT_NAME_CHECKED "PhysXCommon_static"
		ARCHIVE_OUTPUT_NAME_PROFILE "PhysXCommon_static"
		ARCHIVE_OUTPUT_NAME_RELEASE "PhysXCommon_static"
	)
ENDIF()

IF(PHYSXCOMMON_COMPILE_PDB_NAME_DEBUG)
	SET_TARGET_PROPERTIES(PhysXCommon PROPERTIES
		COMPILE_PDB_NAME_DEBUG "${PHYSXCOMMON_COMPILE_PDB_NAME_DEBUG}"
		COMPILE_PDB_NAME_CHECKED "${PHYSXCOMMON_COMPILE_PDB_NAME_CHECKED}"
		COMPILE_PDB_NAME_PROFILE "${PHYSXCOMMON_COMPILE_PDB_NAME_PROFILE}"
		COMPILE_PDB_NAME_RELEASE "${PHYSXCOMMON_COMPILE_PDB_NAME_RELEASE}"
	)
ENDIF()

SET_TARGET_PROPERTIES(PhysXCommon PROPERTIES
	LINK_FLAGS "${PXCOMMON_PLATFORM_LINK_FLAGS}"
	LINK_FLAGS_DEBUG "${PXCOMMON_PLATFORM_LINK_FLAGS_DEBUG}"
	LINK_FLAGS_CHECKED "${PXCOMMON_PLATFORM_LINK_FLAGS_CHECKED}"
	LINK_FLAGS_PROFILE "${PXCOMMON_PLATFORM_LINK_FLAGS_PROFILE}"
	LINK_FLAGS_RELEASE "${PXCOMMON_PLATFORM_LINK_FLAGS_RELEASE}"
)

TARGET_LINK_LIBRARIES(PhysXCommon
	PUBLIC ${PXCOMMON_PLATFORM_LINKED_LIBS}
	PUBLIC PhysXFoundation
	PRIVATE ${PHYSXCOMMON_PLATFORM_LINKED_LIBS}
)

IF(PX_GENERATE_SOURCE_DISTRO)
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSX_COMMON_SOURCE})
    LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_COMMON_INTERNAL_HEADERS})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_COMMON_HEADERS})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GEOMETRY_HEADERS})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GEOMUTILS_HEADERS})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PXCOMMON_PLATFORM_SRC_FILES})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_HEADERS})
	#LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_PXHEADERS})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_CCD_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_COMMON_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_CONTACT_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_CONVEX_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_DISTANCE_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_GJK_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_HF_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_INTERSECTION_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_MESH_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_PCM_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_SWEEP_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_PRUNERS_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_GU_COOKING_SOURCE})
	LIST(APPEND SOURCE_DISTRO_FILE_LIST ${PHYSXCOMMON_COLLISION_HEADERS})
ENDIF()


# enable -fPIC so we can link static libs with the editor
SET_TARGET_PROPERTIES(PhysXCommon PROPERTIES POSITION_INDEPENDENT_CODE TRUE)
