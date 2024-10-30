<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Gadget\Console\Shell\ProcessShellArgs;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand('biprod:lms')]
final class LMS extends Biprod
{
    /** @inheritdoc */
    protected function getArgs(
        InputInterface $input,
        OutputInterface $output
    ): array {
        return array_map(fn(array $args) => new ProcessShellArgs($args), [
            $this->shellCommandFactory->sqlplus('./src/ETL/LMSENRL.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/LMS_ICOLLEGE_RUBRIC_PROG.sql'),
        ]);
    }
}
