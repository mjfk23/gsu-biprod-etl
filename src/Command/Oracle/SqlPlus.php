<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command\Oracle;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;

#[AsCommand('oracle:sqlplus')]
final class SqlPlus extends Oracle
{
    /** @inheritdoc */
    protected function configure(): void
    {
        parent::configure();
        $this->addArgument('sql_file', InputArgument::REQUIRED, 'Path to SQL file');
    }


    /** @inheritdoc */
    protected function getShellArgs(InputInterface $input): array
    {
        /** @var string $database */
        $database = $input->getOption('database');
        /** @var string $sqlFile */
        $sqlFile = $input->getArgument('sql_file');

        return [
            ['sqlplus', '-F', '-L', '-S', "{$database}", "@{$sqlFile}"]
        ];
    }
}
