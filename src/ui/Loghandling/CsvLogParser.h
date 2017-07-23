/*===================================================================
APM_PLANNER Open Source Ground Control Station

(c) 2016 APM_PLANNER PROJECT <http://www.ardupilot.com>

This file is part of the APM_PLANNER project

    APM_PLANNER is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    APM_PLANNER is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with APM_PLANNER. If not, see <http://www.gnu.org/licenses/>.

======================================================================*/
/**
 * @file AsciiLogParser.h
 * @author Arne Wischmann <wischmann-a@gmx.de>
 * @date 09 Okt 2016
 * @brief File providing header for the ascii log parser
 */

#ifndef CSVLOGPARSER_H
#define CSVLOGPARSER_H

#include "ILogParser.h"
#include "IParserCallback.h"
#include "LogParserBase.h"
#include "LogdataStorage.h"

/**
 * @brief The AsciiLogParser class is a parser for ASCII ArduPilot
 *        logfiles (.log extension).
 */
class CSVLogParser : public LogParserBase
{
public:

     /**
     * @brief CSVLogParser - CTOR
     * @param storagePtr - Pointer to a valid LogdataStorage used for data storage
     * @param object - Pointer to a valid call back interface
     */
    explicit CSVLogParser(LogdataStorage::Ptr storagePtr, IParserCallback *object);

    /**
     * @brief ~CSVLogParser - DTOR
     */
    virtual ~CSVLogParser();

    /**
     * @brief parse method reads the logfile. Should be called with an
     *        own thread
     * @param logfile - The file which should be parsed
     * @return - Detailed status of the parsing
     */
    virtual AP2DataPlotStatus parse(QFile &logfile);

private:

    static const char s_TokenSeperator = ',';   /// Token seperator in log file

    QStringList m_tokensToParse;        /// Tokenized input data to parse

};

#endif // CSVLOGPARSER_H
