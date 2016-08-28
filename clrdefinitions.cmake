if(WIN32 AND CLR_CMAKE_TARGET_ARCH_I386 AND BUILD_JIT32)  
  set(CLR_BUILD_JIT32 1)  
else()  
  set(CLR_BUILD_JIT32 0)  
endif()  

if (WIN32)
  set(FEATURE_EVENT_TRACE 1)
endif()
if(CLR_CMAKE_PLATFORM_LINUX AND CLR_CMAKE_TARGET_ARCH_AMD64)
  set(FEATURE_EVENT_TRACE 1)
endif()

if (CLR_CMAKE_TARGET_ARCH_AMD64)
  if (CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DDBG_TARGET_AMD64_UNIX)
  endif()
  add_definitions(-D_TARGET_AMD64_=1)
  add_definitions(-DDBG_TARGET_64BIT=1)
  add_definitions(-DDBG_TARGET_AMD64=1)
  add_definitions(-DDBG_TARGET_WIN64=1)
elseif (CLR_CMAKE_TARGET_ARCH_ARM64)
  if (CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DDBG_TARGET_ARM64_UNIX)
  endif()
  add_definitions(-D_TARGET_ARM64_=1)
  add_definitions(-DDBG_TARGET_64BIT=1)
  add_definitions(-DDBG_TARGET_ARM64=1)
  add_definitions(-DDBG_TARGET_WIN64=1)
  add_definitions(-DFEATURE_MULTIREG_RETURN)
elseif (CLR_CMAKE_TARGET_ARCH_ARM)
  if (CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DDBG_TARGET_ARM_UNIX)
  elseif (WIN32 AND NOT DEFINED CLR_CROSS_COMPONENTS_BUILD)
    # Set this to ensure we can use Arm SDK for Desktop binary linkage when doing native (Arm32) build
    add_definitions(-D_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE=1)
    add_definitions(-D_ARM_WORKAROUND_)
  endif (CLR_CMAKE_PLATFORM_UNIX)
  add_definitions(-D_TARGET_ARM_=1)
  add_definitions(-DDBG_TARGET_32BIT=1)
  add_definitions(-DDBG_TARGET_ARM=1)
elseif (CLR_CMAKE_TARGET_ARCH_I386)
  add_definitions(-D_TARGET_X86_=1)
  add_definitions(-DDBG_TARGET_32BIT=1)
  add_definitions(-DDBG_TARGET_X86=1)
else ()
  clr_unknown_arch()
endif (CLR_CMAKE_TARGET_ARCH_AMD64)

if (CLR_CMAKE_PLATFORM_UNIX)

  if(CLR_CMAKE_PLATFORM_DARWIN)
    add_definitions(-D_XOPEN_SOURCE)
  endif(CLR_CMAKE_PLATFORM_DARWIN)

  if (CLR_CMAKE_PLATFORM_UNIX_AMD64)
    add_definitions(-DUNIX_AMD64_ABI)
  elseif (CLR_CMAKE_PLATFORM_UNIX_ARM)
    add_definitions(-DUNIX_ARM_ABI)
  endif()

endif(CLR_CMAKE_PLATFORM_UNIX)

add_definitions(-D_BLD_CLR)
add_definitions(-DDEBUGGING_SUPPORTED)
add_definitions(-DPROFILING_SUPPORTED)

if(WIN32)
  add_definitions(-DWIN32)
  add_definitions(-D_WIN32)
  add_definitions(-DWINVER=0x0602)
  add_definitions(-D_WIN32_WINNT=0x0602)
  add_definitions(-DWIN32_LEAN_AND_MEAN=1)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
  if(CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386)
    # Only enable edit and continue on windows x86 and x64
    # exclude Linux, arm & arm64
    add_definitions(-DEnC_SUPPORTED)
  endif(CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386)
endif(WIN32)

# Features - please keep them alphabetically sorted

add_definitions(-DFEATURE_APPDOMAIN_RESOURCE_MONITORING)
if(WIN32)
    add_definitions(-DFEATURE_APPX)
endif(WIN32)
if(CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_ARM OR CLR_CMAKE_TARGET_ARCH_ARM64)
    add_definitions(-DFEATURE_ARRAYSTUB_AS_IL)
endif()

add_definitions(-DFEATURE_ASYNC_IO)
add_definitions(-DFEATURE_BCL_FORMATTING)
add_definitions(-DFEATURE_COLLECTIBLE_TYPES)

if(WIN32)
    add_definitions(-DFEATURE_CLASSIC_COMINTEROP)
    add_definitions(-DFEATURE_COMINTEROP)
    add_definitions(-DFEATURE_COMINTEROP_APARTMENT_SUPPORT)
    add_definitions(-DFEATURE_COMINTEROP_UNMANAGED_ACTIVATION)
    add_definitions(-DFEATURE_COMINTEROP_WINRT_MANAGED_ACTIVATION)
endif(WIN32)

add_definitions(-DFEATURE_CORECLR)
if (CLR_CMAKE_PLATFORM_UNIX)
  add_definitions(-DFEATURE_COREFX_GLOBALIZATION)
endif(CLR_CMAKE_PLATFORM_UNIX)
add_definitions(-DFEATURE_CORESYSTEM)
add_definitions(-DFEATURE_CORRUPTING_EXCEPTIONS)
if(CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DFEATURE_DBGIPC_TRANSPORT_DI)
    add_definitions(-DFEATURE_DBGIPC_TRANSPORT_VM)
endif(CLR_CMAKE_PLATFORM_UNIX)
if(FEATURE_EVENT_TRACE)
    add_definitions(-DFEATURE_EVENT_TRACE=1)
endif(FEATURE_EVENT_TRACE)
if(CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DFEATURE_EVENTSOURCE_XPLAT=1)
endif(CLR_CMAKE_PLATFORM_UNIX)
add_definitions(-DFEATURE_EXCEPTIONDISPATCHINFO)
# NetBSD doesn't implement this feature
if(NOT CMAKE_SYSTEM_NAME STREQUAL NetBSD)
    add_definitions(-DFEATURE_HIJACK)
endif(NOT CMAKE_SYSTEM_NAME STREQUAL NetBSD)
add_definitions(-DFEATURE_HOST_ASSEMBLY_RESOLVER)
add_definitions(-DFEATURE_ICASTABLE)
if (CLR_CMAKE_PLATFORM_UNIX OR CLR_CMAKE_TARGET_ARCH_ARM64)
  add_definitions(-DFEATURE_IMPLICIT_TLS)
  set(FEATURE_IMPLICIT_TLS 1)
endif(CLR_CMAKE_PLATFORM_UNIX OR CLR_CMAKE_TARGET_ARCH_ARM64)
add_definitions(-DFEATURE_ISYM_READER)
add_definitions(-DFEATURE_LOADER_OPTIMIZATION)
if (NOT CLR_CMAKE_PLATFORM_UNIX)
add_definitions(-DFEATURE_MANAGED_ETW)
endif(NOT CLR_CMAKE_PLATFORM_UNIX)
add_definitions(-DFEATURE_MANAGED_ETW_CHANNELS)
add_definitions(-DFEATURE_MAIN_CLR_MODULE_USES_CORE_NAME)
add_definitions(-DFEATURE_MERGE_CULTURE_SUPPORT_AND_ENGINE)

if(FEATURE_MERGE_JIT_AND_ENGINE)
  # Disable the following for UNIX altjit on Windows
  add_definitions(-DFEATURE_MERGE_JIT_AND_ENGINE)
endif(FEATURE_MERGE_JIT_AND_ENGINE)
add_definitions(-DFEATURE_MULTICOREJIT)
add_definitions(-DFEATURE_NORM_IDNA_ONLY)
if(CLR_CMAKE_PLATFORM_UNIX)
  add_definitions(-DFEATURE_PAL)
  add_definitions(-DFEATURE_PAL_SXS)
  add_definitions(-DFEATURE_PAL_ANSI)
endif(CLR_CMAKE_PLATFORM_UNIX)
if(CLR_CMAKE_PLATFORM_LINUX)
    add_definitions(-DFEATURE_PERFMAP)
endif(CLR_CMAKE_PLATFORM_LINUX)
add_definitions(-DFEATURE_PREJIT)
add_definitions(-DFEATURE_RANDOMIZED_STRING_HASHING)

add_definitions(-DFEATURE_READYTORUN)
set(FEATURE_READYTORUN 1)

if (CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386)
  add_definitions(-DFEATURE_REJIT)
endif(CLR_CMAKE_TARGET_ARCH_AMD64 OR CLR_CMAKE_TARGET_ARCH_I386)

add_definitions(-DFEATURE_STANDALONE_SN)
add_definitions(-DFEATURE_STRONGNAME_DELAY_SIGNING_ALLOWED)
add_definitions(-DFEATURE_STRONGNAME_MIGRATION)
if (CLR_CMAKE_PLATFORM_UNIX OR CLR_CMAKE_TARGET_ARCH_ARM64)
    add_definitions(-DFEATURE_STUBS_AS_IL)
endif ()
add_definitions(-DFEATURE_SVR_GC)
add_definitions(-DFEATURE_SYMDIFF)
add_definitions(-DFEATURE_SYNTHETIC_CULTURES)
if(CLR_CMAKE_PLATFORM_UNIX_AMD64)
  add_definitions(-DFEATURE_MULTIREG_RETURN)
  add_definitions(-DFEATURE_UNIX_AMD64_STRUCT_PASSING)
  add_definitions(-DFEATURE_UNIX_AMD64_STRUCT_PASSING_ITF)
endif (CLR_CMAKE_PLATFORM_UNIX_AMD64)
add_definitions(-DFEATURE_USE_ASM_GC_WRITE_BARRIERS)
if(CLR_CMAKE_PLATFORM_ARCH_AMD64 AND NOT WIN32)
  add_definitions(-DFEATURE_USE_SOFTWARE_WRITE_WATCH_FOR_GC_HEAP)
endif(CLR_CMAKE_PLATFORM_ARCH_AMD64 AND NOT WIN32)
add_definitions(-DFEATURE_VERSIONING)
if(WIN32)
    add_definitions(-DFEATURE_VERSIONING_LOG)
endif(WIN32)
if(NOT CLR_CMAKE_PLATFORM_UNIX)
    add_definitions(-DFEATURE_WIN32_REGISTRY)
endif(NOT CLR_CMAKE_PLATFORM_UNIX)
add_definitions(-DFEATURE_WINDOWSPHONE)
add_definitions(-DFEATURE_WINMD_RESILIENT)
add_definitions(-D_SECURE_SCL=0)
add_definitions(-DUNICODE)
add_definitions(-D_UNICODE)

add_definitions(-DFEATURE_SPAN_OF_T)
