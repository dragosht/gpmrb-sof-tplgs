#
# Topology for generic Apollolake board with no codec and digital mic array.
#
# APL Host GW DMAC support max 6 playback and max 6 capture channels so some
# pipelines/PCMs/DAIs are commented out to keep within HW bounds. If these
# are needed then they can be used provided other PCMs/pipelines/SSPs are
# commented out in their place.

# Include topology builder
include(`utils.m4')
include(`dai.m4')
include(`ssp.m4')
include(`pipeline.m4')

# Include TLV library
include(`common/tlv.m4')

# Include Token library
include(`sof/tokens.m4')

# Include Apollolake DSP configuration
include(`platform/intel/bxt.m4')
include(`platform/intel/dmic.m4')

DEBUG_START

#
# Define the pipelines
#
# PCM0 ----> volume ----------------+
#                                   |
#                                   |
#                                   +--low latency mixer ----> volume ---->  SSP5 (testpoints)
#				    |
#                                   |
# TONE --------------> volume ------+
#


dnl PIPELINE_PCM_ADD(pipeline,
dnl     pipe id, pcm, max channels, format,
dnl     period, priority, core,
dnl     pcm_min_rate, pcm_max_rate, pipeline_rate,
dnl     time_domain, sched_comp)

# Low Latency playback pipeline 1 on PCM 0 using max 2 channels of s32le.
# 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
	1, 0, 2, s32le,
	1000, 0, 0,
	48000, 48000, 48000)

dnl PIPELINE_ADD(pipeline,
dnl     pipe id, max channels, format,
dnl     period, priority, core,
dnl     sched_comp, time_domain,
dnl     pcm_min_rate, pcm_max_rate, pipeline_rate)

# Tone Playback pipeline 5 using max 2 channels of s32le.
PIPELINE_ADD(sof/pipe-tone.m4,
	     5, 2, s32le,
	     1000, 0, 0,
	     PIPELINE_SCHED_COMP_8,
	     SCHEDULE_TIME_DOMAIN_TIMER,
	     48000, 48000, 48000)


#
# DAIs configuration
#

dnl DAI_ADD(pipeline,
dnl     pipe id, dai type, dai_index, dai_be,
dnl     buffer, periods, format,
dnl     deadline, priority, core, time_domain)

# playback DAI is SSP5 using 2 periods
# Buffers use s32le format, 1000us deadline on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	1, SSP, 5, NoCodec-5,
	PIPELINE_SOURCE_1, 2, s32le,
	1000, 0, 0, SCHEDULE_TIME_DOMAIN_TIMER)

# Connect pipelines together
SectionGraph."pipe-apl-nocodec" {
	index "0"

	lines [
		#tone
		dapm(PIPELINE_MIXER_1, PIPELINE_SOURCE_5)
	]
}


PCM_PLAYBACK_ADD(Port5, 0, PIPELINE_PCM_1)

#
# BE configurations - overrides config in ACPI if present
#

dnl DAI_CONFIG(type, dai_index, link_id, name, ssp_config/dmic_config)
DAI_CONFIG(SSP, 5, 5, NoCodec-5,
	   SSP_CONFIG(DSP_B, SSP_CLOCK(mclk, 24576000, codec_mclk_in),
		      SSP_CLOCK(bclk, 12288000, codec_slave),
		      SSP_CLOCK(fsync, 48000, codec_slave),
		      SSP_TDM(2, 32, 15, 15),
		      SSP_CONFIG_DATA(SSP, 5, 32)))

DEBUG_END
