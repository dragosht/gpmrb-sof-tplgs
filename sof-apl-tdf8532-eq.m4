#
# Topology for generic Apollolake board with TDF8532
#

# Include topology builder
include(`utils.m4')
include(`dai.m4')
include(`pipeline.m4')
include(`ssp.m4')

# Include TLV library
include(`common/tlv.m4')

# Include Token library
include(`sof/tokens.m4')

# Include Apollolake DSP configuration
include(`platform/intel/bxt.m4')


DEBUG_START

#
# Define the pipelines
#
# PCM0 -----> EQ IIR ----> EQ FIR ----> Volume -----> SSP4 (TDF8532)
#

dnl PIPELINE_PCM_ADD(pipeline,
dnl     pipe id, pcm, max channels, format,
dnl     period, priority, core,
dnl     pcm_min_rate, pcm_max_rate, pipeline_rate,
dnl     time_domain, sched_comp)

# Low Latency playback pipeline 1 on PCM 0 using max 2 channels of s32le.
# 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-eq-volume-playback.m4,
	1, 0, 2, s32le,
	1000, 0, 0,
	48000, 48000, 48000)

#
# DAIs configuration
#

dnl DAI_ADD(pipeline,
dnl     pipe id, dai type, dai_index, dai_be,
dnl     buffer, periods, format,
dnl     deadline, priority, core, time_domain)

# playback DAI is SSP4 using 2 periods
# Buffers use s24le format, 1000us deadline on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	1, SSP, 4, SSP4-Codec,
	PIPELINE_SOURCE_1, 2, s32le,
	1000, 0, 0, SCHEDULE_TIME_DOMAIN_TIMER)


# PCM Low Latency, id 0
PCM_PLAYBACK_ADD(Port4, 0, PIPELINE_PCM_1)

#
# BE configurations - overrides config in ACPI if present
#

DAI_CONFIG(SSP, 4, 4, SSP4-Codec,
	   SSP_CONFIG(DSP_B, SSP_CLOCK(mclk, 24576000, codec_mclk_in),
		      SSP_CLOCK(bclk, 12288000, codec_slave),
		      SSP_CLOCK(fsync, 48000, codec_slave),
		      SSP_TDM(2, 32, 15, 15),
		      SSP_CONFIG_DATA(SSP, 4, 32)))


VIRTUAL_DAPM_ROUTE_IN(BtHfp_ssp0_in, SSP, 0, IN, 0)
VIRTUAL_DAPM_ROUTE_OUT(BtHfp_ssp0_out, SSP, 0, OUT, 1)
VIRTUAL_DAPM_ROUTE_IN(hdmi_ssp1_in, SSP, 1, IN, 2)
VIRTUAL_DAPM_ROUTE_IN(dirana_in, SSP, 2, IN, 3)
VIRTUAL_DAPM_ROUTE_IN(dirana_aux_in, SSP, 2, IN, 4)
VIRTUAL_DAPM_ROUTE_IN(dirana_tuner_in, SSP, 2, IN, 5)
VIRTUAL_DAPM_ROUTE_OUT(dirana_out, SSP, 2, OUT, 6)
VIRTUAL_DAPM_ROUTE_IN(Modem_ssp3_in, SSP, 3, IN, 7)
VIRTUAL_DAPM_ROUTE_OUT(Modem_ssp3_out, SSP, 3, OUT, 8)
VIRTUAL_DAPM_ROUTE_OUT(codec0_out, SSP, 4, OUT, 9)
VIRTUAL_DAPM_ROUTE_IN(TestPin_ssp5_in, SSP, 5, IN, 10)
VIRTUAL_DAPM_ROUTE_OUT(TestPin_ssp5_out, SSP, 5, OUT, 11)
VIRTUAL_WIDGET(ssp0 Tx, out_drv, 12)
VIRTUAL_WIDGET(ssp0 Rx, out_drv, 13)
VIRTUAL_WIDGET(ssp1 Rx, out_drv, 14)
VIRTUAL_WIDGET(ssp2 Tx, out_drv, 15)
VIRTUAL_WIDGET(ssp2 Rx, out_drv, 16)
VIRTUAL_WIDGET(ssp3 Tx, out_drv, 17)
VIRTUAL_WIDGET(ssp3 Rx, out_drv, 18)
VIRTUAL_WIDGET(ssp4 Tx, out_drv, 19)
VIRTUAL_WIDGET(ssp5 Tx, out_drv, 20)
VIRTUAL_WIDGET(ssp5 Rx, out_drv, 21)

DEBUG_END
