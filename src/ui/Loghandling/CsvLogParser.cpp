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
 * @file AsciiLogParser.cpp
 * @author Arne Wischmann <wischmann-a@gmx.de>
 * @author Michael Carpenter <malcom2073@gmail.com>
 * @date 09 Okt 2016
 * @brief File providing implementation for the ascii log parser
 */

#include "CsvLogParser.h"
#include "logging.h"


CSVLogParser::CSVLogParser(LogdataStorage::Ptr storagePtr, IParserCallback *object) :
    LogParserBase (storagePtr, object)
{
    QLOG_DEBUG() << "CSVLogParser::CSVLogParser - CTOR";
}

CSVLogParser::~CSVLogParser()
{
    QLOG_DEBUG() << "CSVLogParser::CSVLogParser - DTOR";
}

AP2DataPlotStatus CSVLogParser::parse(QFile &logfile)
{
    QLOG_DEBUG() << "CSVLogParser::parse:" << logfile.fileName();

    if(!m_dataStoragePtr || !m_callbackObject)
    {
        QLOG_ERROR() << "CSVLogParser::parse - No valid datamodel or callback object - parsing stopped";
        return m_logLoadingState;
    }

    bool headerLine = true;
    QStringList labels;

    m_activeTimestamp = m_possibleTimestamps.at(0);

    while (!logfile.atEnd() && !m_stop)
    {
        m_callbackObject->onProgress(logfile.pos(),logfile.size());
        QString line = logfile.readLine();
        line = line.remove(QChar('\n'));
        line = line.remove(QChar('\r'));
        m_tokensToParse.clear();
        m_tokensToParse = line.split(QChar(s_TokenSeperator));

        if(m_tokensToParse.size() > 0)
        {
            if(headerLine)
            {
                QStringList::Iterator iter;
                QString format;
                for (iter = m_tokensToParse.begin(); iter != m_tokensToParse.end(); ++iter)
                {
                    labels.push_back(iter->trimmed());
                    format.append('i');
                }
                m_dataStoragePtr->addDataType(QString("All"), 0, 40, format, labels, 1);
                headerLine = false;
            }
            else
            {
                if(labels.size() <= m_tokensToParse.size())
                {
                    QList<NameValuePair> data;
                    for (int i = 0; i < labels.size(); ++i)
                    {
                        NameValuePair element(labels.at(i), m_tokensToParse.at(i).trimmed().toInt());
                        data.append(element);
                    }
                    m_dataStoragePtr->addDataRow(QString("All"), data);
                    m_MessageCounter++;
                }
                else
                {
                    QLOG_DEBUG() << "CSVLogParser::parse(): label token mismatch: " << line;
                }
            }
        }
        else
        {
            QLOG_DEBUG() << "CSVLogParser::parse(): No tokens found in line: " << line;
            m_logLoadingState.corruptDataRead(static_cast<int>(m_MessageCounter), "No data for parsing found.");
        }
    }

    m_dataStoragePtr->setTimeStamp(m_activeTimestamp.m_name, m_activeTimestamp.m_divisor);
    return m_logLoadingState;
}

