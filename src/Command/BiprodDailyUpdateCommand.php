<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand('biprod:daily-update')]
final class BiprodDailyUpdateCommand extends BiprodHourlyUpdateCommand
{
    /** @inheritdoc */
    protected function getCommands(
        InputInterface $input,
        OutputInterface $output
    ): array {
        return [
            ...parent::getCommands($input, $output),
            [$this->sqlplus, 'D2L_ORGANIZATIONAL_UNIT_ANCESTOR'],
            [$this->sqlplus, 'D2L_ORGANIZATIONAL_UNIT'],
            [$this->sqlplus, 'D2L_USER_ENROLLMENT'],
            [$this->sqlplus, 'D2L_USER'],
            [$this->sqlplus, 'D2L_OUTCOME_DETAIL'],
            [$this->sqlplus, 'LMSENRL'],
            [$this->sqlplus, 'LMS_ICOLLEGE_RUBRIC_PROG'],
            [$this->sqlplus, 'SKILL_PROGRAM'],
            [$this->sqlplus, 'SKILL_LEVEL'],
            [$this->sqlplus, 'SKILL_DETAIL'],
            [$this->sqlplus, 'SKILL_ASSESSMENT'],
        ];
    }
}
