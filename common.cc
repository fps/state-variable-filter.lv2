static inline float db_to_gain( float x)
{
    return expf(0.05f * x * logf(10.0));
}

