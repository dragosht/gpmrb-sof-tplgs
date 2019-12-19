# Include topology builder
include(`utils.m4')
include(`dai.m4')
include(`pipeline.m4')
include(`ssp.m4')

# Include TLV library
include(`common/tlv.m4')

# Include Token library
include(`sof/tokens.m4')

# Include Baytrail DSP configuration
include(`platform/intel/byt.m4')

#
# Define the pipelines
#
# PCM0 ----> volume ----> SSP2
#

# Low Latency playback pipeline 1 on PCM 0 using max 2 channels of s32le.
# 1000us deadline on core 0 with priority 0
PIPELINE_PCM_DAI_ADD(sof/pipe-volume-playback.m4,
	1, 0, 2, s32le,
	1000, 0, 0, SSP, 2, s32le, 2,
	48000, 48000, 48000)


#
# DAI configuration
#
# SSP port 2 is our only pipeline DAI
#

# playback DAI is SSP2 using 2 periods
# Buffers use s24le format, 1000us deadline on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	1, SSP, 2, NoCodec-2,
	PIPELINE_SOURCE_1, 2, s24le,
	1000, 0, 0)


# PCM Playback
PCM_PLAYBACK_ADD(Port0, 0, PIPELINE_PCM_1)

#
# BE configurations - overrides config in ACPI if present
#
DAI_CONFIG(SSP, 2, 2, NoCodec-2,
	   SSP_CONFIG(I2S, SSP_CLOCK(mclk, 19200000, codec_mclk_in),
		      SSP_CLOCK(bclk, 2400000, codec_slave),
		      SSP_CLOCK(fsync, 48000, codec_slave),
		      SSP_TDM(2, 25, 3, 3),
		      SSP_CONFIG_DATA(SSP, 2, 24, 0, SSP_QUIRK_LBM)))

VIRTUAL_WIDGET(ssp2 Rx, out_drv, 1)
VIRTUAL_WIDGET(ssp2 Tx, out_drv, 2)
VIRTUAL_WIDGET(ssp0 Tx, out_drv, 3)
VIRTUAL_WIDGET(ssp0 Rx, out_drv, 4)
VIRTUAL_DAPM_ROUTE_IN(modem_in, SSP, 0, IN, 0)
VIRTUAL_DAPM_ROUTE_OUT(modem_out, SSP, 0, OUT, 1)
