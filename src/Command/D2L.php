<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Gadget\Console\Shell\ProcessShellArgs;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand('biprod:d2l')]
final class D2L extends Biprod
{
    /** @inheritdoc */
    protected function getArgs(
        InputInterface $input,
        OutputInterface $output
    ): array {
        return array_map(fn(array $args) => new ProcessShellArgs($args), [
            $this->shellCommandFactory->sqlplus('./src/ETL/D2L_ORGANIZATIONAL_UNIT_ANCESTOR.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/D2L_ORGANIZATIONAL_UNIT.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/D2L_USER_ENROLLMENT.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/D2L_USER.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/D2L_OUTCOME_DETAIL.sql'),
        ]);
    }
}
