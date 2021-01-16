#include <cmath>
#include <lv2.h>

#include "common.cc"

struct svf {
    float *ports[7];
    float z1;
    float z2;
    float sample_rate;
    float freq;
    float q;
    float lowgain;
    float bandgain;
    float highgain;
    unsigned frame_index;
    svf(float sample_rate) : z1(0.0f), z2(0.0f), sample_rate(sample_rate), freq(0.01f), q(0.5f), lowgain(0.0f), bandgain(0.0f), highgain(0.0f), frame_index(0) {

    }
};

static LV2_Handle instantiate(const LV2_Descriptor *descriptor, double sample_rate, const char *bundle_path, const LV2_Feature *const *features)
{
    return (LV2_Handle)(new svf(sample_rate));
}

static void cleanup(LV2_Handle instance)
{
    delete ((svf*)instance);
}

static void connect_port(LV2_Handle instance, uint32_t port, void *data_location)
{
    ((svf*)instance)->ports[port] = (float*)data_location;
}

#define ALPHA 0.99f

#define PARAM_UPDATE 8

static void run(LV2_Handle instance, uint32_t sample_count)
{
    svf *tinstance = (svf*)(instance);

    const float p_freq = tinstance->ports[2][0] / tinstance->sample_rate;
    const float p_q = tinstance->ports[3][0];
    const float p_lowgain = db_to_gain(tinstance->ports[4][0]);
    const float p_bandgain = db_to_gain(tinstance->ports[5][0]);
    const float p_highgain = db_to_gain(tinstance->ports[6][0]);

    for(uint32_t sample_index = 0; sample_index < sample_count; ++sample_index)
    {
        if (0 == tinstance->frame_index % PARAM_UPDATE)
        {
            tinstance->freq = ALPHA * tinstance->freq + (1.0f - ALPHA) * p_freq;
            tinstance->q = ALPHA * tinstance->q + (1.0f - ALPHA) * p_q;
            tinstance->lowgain = ALPHA * tinstance->lowgain + (1.0f - ALPHA) * p_lowgain;
            tinstance->bandgain = ALPHA * tinstance->bandgain + (1.0f - ALPHA) * p_bandgain;
            tinstance->highgain = ALPHA * tinstance->highgain + (1.0f - ALPHA) * p_highgain;
        }
        ++(tinstance->frame_index);
 
        const float w = 2.0f * tanf(M_PI * tinstance->freq);
        const float a = w / tinstance->q;
        const float b = w*w;
        const float c1 = (a + b)/(1 + 0.5f*a + 0.25f * b);
        const float c2 = b / (a + b);
        
        const float d0_high = 1.0f - 0.5f * c1 + c1 * c2 * 0.25f;
        const float d1_band = 1.0f - c2;
        const float d0_band = d1_band * c1 * 0.5f;
        const float d0_low = c1 * c2 * 0.25f;
    
        const float in = tinstance->ports[0][sample_index];
        float out = 0;

        const float x = in - tinstance->z1 - tinstance->z2 + 1e-20f;
        out += tinstance->highgain * d0_high * x;
        out += tinstance->bandgain * (d0_band * x + d1_band * tinstance->z1);
        tinstance->z2 += c2 * tinstance->z1;
        out += tinstance->lowgain * (d0_low * x + tinstance->z2);
        tinstance->z1 += c1 * x;

        tinstance->ports[1][sample_index] = out;
    }
}

static const LV2_Descriptor descriptor = {
    "http://fps.io/plugins/state-variable-filter-v1",
    instantiate,
    connect_port,
    nullptr, // activate
    run,
    nullptr, // deactivate
    cleanup,
    nullptr // extension_data
};

LV2_SYMBOL_EXPORT const LV2_Descriptor* lv2_descriptor (uint32_t index)
{
    if (0 == index) return &descriptor;
    else return nullptr;
}


