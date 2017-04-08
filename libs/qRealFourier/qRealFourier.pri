# qRealFourier math library
message(Adding qRealFourier $$PWD)
INCLUDEPATH += $$PWD/headers \
    $$PWD/fftreal

HEADERS +=     $$PWD/fftreal/Array.h \
    $$PWD/fftreal/def.h \
    $$PWD/fftreal/DynArray.h \
    $$PWD/fftreal/FFTReal.h \
    $$PWD/fftreal/FFTRealFixLen.h \
    $$PWD/fftreal/FFTRealFixLenParam.h \
    $$PWD/fftreal/FFTRealPassDirect.h \
    $$PWD/fftreal/FFTRealPassInverse.h \
    $$PWD/fftreal/FFTRealSelect.h \
    $$PWD/fftreal/FFTRealUseTrigo.h \
    $$PWD/fftreal/OscSinCos.h \
    $$PWD/headers/qcomplexnumber.h \
    $$PWD/headers/qfouriercalculator.h \
    $$PWD/headers/qfourierfixedcalculator.h \
    $$PWD/headers/qfouriertransformer.h \
    $$PWD/headers/qfouriervariablecalculator.h \
    $$PWD/headers/qwindowfunction.h
    

SOURCES +=     $$PWD/sources/qcomplexnumber.cpp \
    $$PWD/sources/qfouriercalculator.cpp \
    $$PWD/sources/qfourierfixedcalculator.cpp \
    $$PWD/sources/qfouriertransformer.cpp \
    $$PWD/sources/qfouriervariablecalculator.cpp \
    $$PWD/sources/qwindowfunction.cpp
